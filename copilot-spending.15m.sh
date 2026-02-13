#!/bin/bash
# <xbar.title>GitHub Copilot Usage</xbar.title>
# <xbar.version>v3.1</xbar.version>
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
# On the next month, on 1st day set this number to 0 
PRE_UPGRADE_USAGE=0

# Icon theme: "dark" (white icon for dark menu bar) or "light" (black icon for light menu bar)
ICON_THEME="dark"
# ===================================

# GitHub logo (black - for light menu bar)
GITHUB_ICON_LIGHT="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAEqWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS41LjAiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgZXhpZjpQaXhlbFhEaW1lbnNpb249IjE2IgogICBleGlmOlBpeGVsWURpbWVuc2lvbj0iMTYiCiAgIGV4aWY6Q29sb3JTcGFjZT0iMSIKICAgdGlmZjpJbWFnZVdpZHRoPSIxNiIKICAgdGlmZjpJbWFnZUxlbmd0aD0iMTYiCiAgIHRpZmY6UmVzb2x1dGlvblVuaXQ9IjIiCiAgIHRpZmY6WFJlc29sdXRpb249IjcyLzEiCiAgIHRpZmY6WVJlc29sdXRpb249IjcyLzEiCiAgIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiCiAgIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjYtMDItMTNUMTc6MzA6MzEtMDM6MDAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjYtMDItMTNUMTc6MzA6MzEtMDM6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJwcm9kdWNlZCIKICAgICAgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWZmaW5pdHkgMy4wLjMiCiAgICAgIHN0RXZ0OndoZW49IjIwMjYtMDItMTNUMTc6MzA6MzEtMDM6MDAiLz4KICAgIDwvcmRmOlNlcT4KICAgPC94bXBNTTpIaXN0b3J5PgogIDwvcmRmOkRlc2NyaXB0aW9uPgogPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0iciI/PscbTZAAAAGBaUNDUHNSR0IgSUVDNjE5NjYtMi4xAAAokXWR3yuDURjHPxsitqbsQnGxhKtNftTiRtkSSlozZbjZ3v1S+/H2vltabpXbFSVu/LrgL+BWuVaKSMm1XBI3rNfz2mqSPafnPJ/zPed5Ouc5YA2llYzeOAiZbF4LTvlci+ElV/MLVuw46cIWUXR1IhCYpa593GEx443HrFX/3L/WFovrClhahMcVVcsLTwvPruVVk7eFnUoqEhM+FXZrckHhW1OPVvjZ5GSFv0zWQkE/WNuFXclfHP3FSkrLCMvL6c2kC0r1PuZLbPHswrzEHvFudIJM4cPFDJP48TLEmMxePAwzICvq5A/+5M+Rk1xFZpUiGqskSZHHLWpBqsclJkSPy0hTNPv/t696YmS4Ut3mg6Ynw3jrg+YtKJcM4/PQMMpH0PAIF9lafu4ARt9FL9W03n1wbMDZZU2L7sD5JnQ+qBEt8iM1iFsTCXg9AXsYOq6hdbnSs+o+x/cQWpevuoLdPeiX846VbyOgZ8foYTH6AAAACXBIWXMAAAsTAAALEwEAmpwYAAABh0lEQVQ4ja3SPWsUURTG8d/uignmTirxMqiNIFgpImn0IwiCEQQFmxA/hClivoAIYiFqIxaCEhFfsFQb0cJKCGKjMFywEJwJqybRYu/gGHbBwtOd+zz/Z87ce3omVBnjbhzL7dsqpS/jfL0x4HlcxoFt0kcsVSndGRtQxjiLmzgzaapcD7BQpfQV+h3haoYfoRkDNlk7jWt/TVDGeAqr2MQMAk7gU/btxyus56AezlYp3WsDXmZgEzNVSt/HzV7GOI0aA7ypUprrlzEOcDR7nk6CoUppiGe5PVzGONXHIezKh6uT4E61np040sePjrjvHwK6nmHf6H3bsefLGKcmkfkO5nO7hbVB3TS/ihDmsAc7cLIIYViE8KFumo0MzhYhnMMVf7bzeZXS7XYPloyebhHfcBcLnY8v4haOd84ukRepSukdlnEDF3EQ1zvmx9v+ZrlK6bU8shyyUsa4hff4bLSVa1luL/pnhldabtCNrZvmRRHCfezFk7pp1qEIYQPTuFCl9ND/rN/pjHh8JgDtHwAAAABJRU5ErkJggg=="

# GitHub logo (white - for dark menu bar)
GITHUB_ICON_DARK="iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAEqWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS41LjAiPgogPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iCiAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyIKICAgIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIKICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIgogICAgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIKICAgZXhpZjpQaXhlbFhEaW1lbnNpb249IjE2IgogICBleGlmOlBpeGVsWURpbWVuc2lvbj0iMTYiCiAgIGV4aWY6Q29sb3JTcGFjZT0iMSIKICAgdGlmZjpJbWFnZVdpZHRoPSIxNiIKICAgdGlmZjpJbWFnZUxlbmd0aD0iMTYiCiAgIHRpZmY6UmVzb2x1dGlvblVuaXQ9IjIiCiAgIHRpZmY6WFJlc29sdXRpb249IjcyLzEiCiAgIHRpZmY6WVJlc29sdXRpb249IjcyLzEiCiAgIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiCiAgIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIKICAgeG1wOk1vZGlmeURhdGU9IjIwMjYtMDItMTNUMTc6Mjc6NTQtMDM6MDAiCiAgIHhtcDpNZXRhZGF0YURhdGU9IjIwMjYtMDItMTNUMTc6Mjc6NTQtMDM6MDAiPgogICA8eG1wTU06SGlzdG9yeT4KICAgIDxyZGY6U2VxPgogICAgIDxyZGY6bGkKICAgICAgc3RFdnQ6YWN0aW9uPSJwcm9kdWNlZCIKICAgICAgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWZmaW5pdHkgMy4wLjMiCiAgICAgIHN0RXZ0OndoZW49IjIwMjYtMDItMTNUMTc6Mjc6NTQtMDM6MDAiLz4KICAgIDwvcmRmOlNlcT4KICAgPC94bXBNTTpIaXN0b3J5PgogIDwvcmRmOkRlc2NyaXB0aW9uPgogPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0iciI/PjcIhQcAAAGBaUNDUHNSR0IgSUVDNjE5NjYtMi4xAAAokXWR3yuDURjHPxsitqbsQnGxhKtNftTiRtkSSlozZbjZ3v1S+/H2vltabpXbFSVu/LrgL+BWuVaKSMm1XBI3rNfz2mqSPafnPJ/zPed5Ouc5YA2llYzeOAiZbF4LTvlci+ElV/MLVuw46cIWUXR1IhCYpa593GEx443HrFX/3L/WFovrClhahMcVVcsLTwvPruVVk7eFnUoqEhM+FXZrckHhW1OPVvjZ5GSFv0zWQkE/WNuFXclfHP3FSkrLCMvL6c2kC0r1PuZLbPHswrzEHvFudIJM4cPFDJP48TLEmMxePAwzICvq5A/+5M+Rk1xFZpUiGqskSZHHLWpBqsclJkSPy0hTNPv/t696YmS4Ut3mg6Ynw3jrg+YtKJcM4/PQMMpH0PAIF9lafu4ARt9FL9W03n1wbMDZZU2L7sD5JnQ+qBEt8iM1iFsTCXg9AXsYOq6hdbnSs+o+x/cQWpevuoLdPeiX846VbyOgZ8foYTH6AAAACXBIWXMAAAsTAAALEwEAmpwYAAABHElEQVQ4jZ2SPUsDQRCG37uA+QBFUMHCRlFJF0TwN1ilE0Qba8uUksY/kDa1jZUIQS3sLLQSK23TWYo2EeKhPjZzYVjvzsOBLfb9YmZ2I+UUMC9p064PURS95GlD4x4w5HcNgf0i4wxwlmEM6xyYzQo4McEFMMowjowDOA3NbSM+gSowZ9iGnbZhdeDbtDs+4NYHFIxZMw3AfQpWgHcDL0ss+cq0H0A1ltSU1DB+8FeA00xJasWSEkculQjwmnE6wtjaeiyxgyfTfgG1lBgAr8AzcAPsTkhN/sgBcOee9dont4AE2HZvfej4Tsa/2Arb61oHi8AqEDuuGZiP82Y8At5sF+sOXzFjAnQLVwysAX1gwWHTQA9YLjT/p34ANjK8CAXFYlMAAAAASUVORK5CYII="

# Select icon based on theme
if [[ "$ICON_THEME" == "light" ]]; then
  GITHUB_ICON="$GITHUB_ICON_LIGHT"
else
  GITHUB_ICON="$GITHUB_ICON_DARK"
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

echo "\n ${pct}% | image=$GITHUB_ICON color=$color sfcolor=$color"
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
