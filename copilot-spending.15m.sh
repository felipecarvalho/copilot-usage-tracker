#!/bin/bash
# <xbar.title>GitHub Copilot Usage</xbar.title>
# <xbar.version>v3.2</xbar.version>
# <xbar.desc>Shows GitHub Copilot premium request usage percentage</xbar.desc>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# ========== CONFIGURATION ==========
GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_PAT_HERE}"
GITHUB_USERNAME="${GITHUB_USERNAME:-YOUR_GITHUB_USERNAME}"

# Your Copilot plan's monthly limit:
# Free: 50 | Pro: 300 | Pro+: 1500
PLAN_LIMIT=300

# Set the currently usage requests if you is upgrading from a lower plan
# Eg: If you are upgrading from Pro to Pro+ and the currently usage is 100, set it to 150
# Set to 0 on 1st day of month
PRE_UPGRADE_USAGE=0

# Icon theme: "dark" (white icon for dark menu bar) or "light" (black icon for light menu bar)
ICON_THEME="dark"
# ===================================

# GitHub Copilot logo (black - for light menu bar)
GITHUB_COPILOT_ICON_LIGHT="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAEqWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS41LjAiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgZXhpZjpQaXhlbFhEaW1lbnNpb249IjE2IgogICBleGlmOlBpeGVsWURpbWVuc2lvbj0iMTYiCiAgIGV4aWY6Q29sb3JTcGFjZT0iMSIKICAgdGlmZjpJbWFnZVdpZHRoPSIxNiIKICAgdGlmZjpJbWFnZUxlbmd0aD0iMTYiCiAgIHRpZmY6UmVzb2x1dGlvblVuaXQ9IjIiCiAgIHRpZmY6WFJlc29sdXRpb249IjcyLzEiCiAgIHRpZmY6WVJlc29sdXRpb249IjcyLzEiCiAgIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiCiAgIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjYtMDItMTNUMTg6MzA6MzItMDM6MDAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjYtMDItMTNUMTg6MzA6MzItMDM6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJwcm9kdWNlZCIKICAgICAgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWZmaW5pdHkgMy4wLjMiCiAgICAgIHN0RXZ0OndoZW49IjIwMjYtMDItMTNUMTg6MzA6MzItMDM6MDAiLz4KICAgIDwvcmRmOlNlcT4KICAgPC94bXBNTTpIaXN0b3J5PgogIDwvcmRmOkRlc2NyaXB0aW9uPgogPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0iciI/PtpfaXcAAAGBaUNDUHNSR0IgSUVDNjE5NjYtMi4xAAAokXWR3yuDURjHPzYiLArlYhdL42oTU4sbZUsoac2U4WZ790vtx9v7bmm5VW5XlLjx64K/gFvlWikiJddySdyg1/Paakv2nJ7zfM73nOfpnOeAJZRWMnrjEGSyeS045XMshpcczS9YsNGDHWtE0dWJQGCWuvZxR4MZb9xmrfrn/rW2WFxXoKFFeFxRtbzwtPDsWl41eVu4W0lFYsKnwi5NLih8a+rRMj+bnCzzl8laKOgHS6ewI1nD0RpWUlpGWF6OM5MuKJX7mC9pj2cX5iX2idvRCTKFDwczTOLHyzBjMntx42FQVtTJH/rNnyMnuYrMKkU0VkmSIo9L1IJUj0tMiB6XkaZo9v9vX/XEiKdcvd0HTU+G8dYPzVvwXTKMz0PD+D4C6yNcZKv5uQMYfRe9VNWc+9CxAWeXVS26A+eb0PugRrTIr2QVtyQS8HoCtjB0XUPrcrlnlX2O7yG0Ll91Bbt7MCDnO1Z+ABRPZ8DWojRbAAAACXBIWXMAAAsTAAALEwEAmpwYAAABKUlEQVQ4ja3SMShFcRQG8J8nj6SUmRciBlkZGESZZDIwGkwsNmZM2CwGi9EskizsYlCyMishBp7hnau/23ulOHW693z/73z/755z+WPU1cALaEdf1Le4x+dvREdwhXIur+KspoMCttGCO0xiLM7OcIJePGO5mpsFzCZ1Kbm9I8HnMF/N+l00ZdGPg8i+BC8F99s2tKEHQ1E3YBGPkUuBwXBwWzORVmyE1Qec4gbrqI9cD+w0OGWsZSLHybd2qgy22nozvDPhH/FzVY1B7sZO0rybzKc51/OjqA/SDN4SgTKm4r2YF9hS2Wk5DrNbphKB6cRdU3A/sJkRBlV+lHOsYDSIkqZRrOIChxiQizpMYB9PeA/Bc7zgGnsYzzdVi6LK0Lrwist4/n98AbktTYTgu37sAAAAAElFTkSuQmCC%"

# GitHub Copilot logo (white - for dark menu bar)
GITHUB_COPILOT_ICON_DARK="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAEqWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS41LjAiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgZXhpZjpQaXhlbFhEaW1lbnNpb249IjE2IgogICBleGlmOlBpeGVsWURpbWVuc2lvbj0iMTYiCiAgIGV4aWY6Q29sb3JTcGFjZT0iMSIKICAgdGlmZjpJbWFnZVdpZHRoPSIxNiIKICAgdGlmZjpJbWFnZUxlbmd0aD0iMTYiCiAgIHRpZmY6UmVzb2x1dGlvblVuaXQ9IjIiCiAgIHRpZmY6WFJlc29sdXRpb249IjcyLzEiCiAgIHRpZmY6WVJlc29sdXRpb249IjcyLzEiCiAgIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiCiAgIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjYtMDItMTNUMTg6Mjg6NDctMDM6MDAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjYtMDItMTNUMTg6Mjg6NDctMDM6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJwcm9kdWNlZCIKICAgICAgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWZmaW5pdHkgMy4wLjMiCiAgICAgIHN0RXZ0OndoZW49IjIwMjYtMDItMTNUMTg6Mjg6NDctMDM6MDAiLz4KICAgIDwvcmRmOlNlcT4KICAgPC94bXBNTTpIaXN0b3J5PgogIDwvcmRmOkRlc2NyaXB0aW9uPgogPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0iciI/PiSOb8wAAAGBaUNDUHNSR0IgSUVDNjE5NjYtMi4xAAAokXWR3yuDURjHPzYiLArlYhdL42oTU4sbZUsoac2U4WZ790vtx9v7bmm5VW5XlLjx64K/gFvlWikiJddySdyg1/Paakv2nJ7zfM73nOfpnOeAJZRWMnrjEGSyeS045XMshpcczS9YsNGDHWtE0dWJQGCWuvZxR4MZb9xmrfrn/rW2WFxXoKFFeFxRtbzwtPDsWl41eVu4W0lFYsKnwi5NLih8a+rRMj+bnCzzl8laKOgHS6ewI1nD0RpWUlpGWF6OM5MuKJX7mC9pj2cX5iX2idvRCTKFDwczTOLHyzBjMntx42FQVtTJH/rNnyMnuYrMKkU0VkmSIo9L1IJUj0tMiB6XkaZo9v9vX/XEiKdcvd0HTU+G8dYPzVvwXTKMz0PD+D4C6yNcZKv5uQMYfRe9VNWc+9CxAWeXVS26A+eb0PugRrTIr2QVtyQS8HoCtjB0XUPrcrlnlX2O7yG0Ll91Bbt7MCDnO1Z+ABRPZ8DWojRbAAAACXBIWXMAAAsTAAALEwEAmpwYAAABUUlEQVQ4jaWTsSvuYRTHPw95XVJvmXm7REy2GwODKKV0pzswGkwsFv8AJvdudzFYjHYkWdgMIim9K7MIMfCxnF89ve8rg1Onnu/39z3fc37n6YFvRmpEqk1AFzAQ1DVwk1J6/9JRHVXPrY9zdfTTCaLrP6ADqAJTwHh8PgIOgH7gEVium0ZdUGczXMm6d2f8nDrfaPSqWsnwoLoTOZDxFbVa4KYgO4E+YDhwC7AI3EUuBQcwAvSp5cKxrK7HqLfqoXqlrqnNkWvBHYZGdVUto+5n//pTTWrd9RZ8aIrYo+aqWkPcq/7PijeL/ajteUGtQXOI/qgvmYHqTJxLtQZ/1ffApazLTGbwO5vuR2jf1I0U5BCwAbQBu8AJcJpSeimKgF/AGDAN3AMrKaXL2iVNqtvqg/qqHkc+qRfqljqRL/ezx1QCKkAP8AycpZSeG2m/HR89bpKSSEszngAAAABJRU5ErkJggg==%"

# Select icon based on theme
if [[ "$ICON_THEME" == "light" ]]; then
  GITHUB_COPILOT_ICON="$GITHUB_COPILOT_ICON_LIGHT"
else
  GITHUB_COPILOT_ICON="$GITHUB_COPILOT_ICON_DARK"
fi

if [[ -z "$GITHUB_TOKEN" || "$GITHUB_TOKEN" == "YOUR_GITHUB_PAT_HERE" || -z "$GITHUB_USERNAME" || "$GITHUB_USERNAME" == "YOUR_GITHUB_USERNAME" ]]; then
  echo ":sparkle: Setup | sfcolor=orange"
  echo "---"
  echo "Edit this plugin and set:"
  echo "  GITHUB_TOKEN"
  echo "  GITHUB_USERNAME"
  exit 0
fi

current_year=$(date -u +%Y)
current_month=$(date -u +%-m)

response=$(curl -s -w "\n%{http_code}" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/users/$GITHUB_USERNAME/settings/billing/premium_request/usage?year=$current_year&month=$current_month" 2>&1)

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [[ "$http_code" != "200" ]]; then
  echo ":exclamationmark.triangle.fill: Err | sfcolor=red"
  echo "---"
  echo "HTTP $http_code"
  echo "Refresh | refresh=true"
  exit 0
fi

# Get total requests and subtract pre-upgrade usage
total_raw=$(echo "$body" | jq '[.usageItems[] | select(.product == "Copilot") | .grossQuantity] | add // 0')
total_float=$(echo "$total_raw - $PRE_UPGRADE_USAGE" | bc)
total_requests=${total_float%.*}

# Ensure non-negative
if [[ $total_requests -lt 0 ]]; then
  total_requests=0
  total_float="0.0"
fi

pct=$(echo "scale=1; $total_float * 100 / $PLAN_LIMIT" | bc)
pct_int=${pct%.*}

# Handle empty pct_int
[[ -z "$pct_int" ]] && pct_int=0

[[ $pct_int -gt 100 ]] && pct="100.0"
[[ $pct_int -lt 0 ]] && pct="0.0" && pct_int=0

if [[ $pct_int -lt 50 ]]; then
  color="#3fb950"
elif [[ $pct_int -lt 80 ]]; then
  color="#d29922"
else
  color="#f85149"
fi

bar_len=10
filled=$((pct_int * bar_len / 100))
empty=$((bar_len - filled))
bar=$(printf '▓%.0s' $(seq 1 $filled 2>/dev/null) || echo "")
bar+=$(printf '░%.0s' $(seq 1 $empty 2>/dev/null) || echo "")

echo "\n ${pct}% | image=$GITHUB_COPILOT_ICON"
echo "---"
echo "Premium Requests | size=11 color=gray"
echo "$bar ${total_requests}/${PLAN_LIMIT} « ${pct}% | font=Menlo size=13 color=$color"
echo "---"

days_left=$(($(date -v1d -v+1m +%s) - $(date +%s)))
days_left=$((days_left / 86400))
echo "Resets in $days_left days | size=12 color=gray"
echo "---"
echo "View on GitHub | href=https://github.com/settings/copilot/features"
echo "Refresh | refresh=true"
