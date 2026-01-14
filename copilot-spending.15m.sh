#!/bin/bash

# <xbar.title>GitHub Copilot Usage</xbar.title>
# <xbar.version>v3.0</xbar.version>
# <xbar.desc>Shows GitHub Copilot premium request usage percentage</xbar.desc>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>

# ========== CONFIGURATION ==========
GITHUB_TOKEN="${GITHUB_TOKEN:-YOUR_GITHUB_PAT_HERE}"
GITHUB_USERNAME="${GITHUB_USERNAME:-YOUR_GITHUB_USERNAME}"

# Your Copilot plan's monthly limit:
#   Free: 50 | Pro: 300 | Pro+: 1500
PLAN_LIMIT=300
# ===================================

if [[ -z "$GITHUB_TOKEN" || "$GITHUB_TOKEN" == "YOUR_GITHUB_PAT_HERE" || -z "$GITHUB_USERNAME" || "$GITHUB_USERNAME" == "YOUR_GITHUB_USERNAME" ]]; then
    echo ":sparkle: Setup | sfcolor=orange"
    echo "---"
    echo "Edit this plugin and set:"
    echo "  GITHUB_TOKEN"
    echo "  GITHUB_USERNAME"
    exit 0
fi

current_year=$(date +%Y)
current_month=$(date +%-m)

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

total_float=$(echo "$body" | jq '[.usageItems[] | select(.product == "Copilot") | .grossQuantity] | add // 0')
total_requests=${total_float%.*}

pct=$(echo "scale=1; $total_float * 100 / $PLAN_LIMIT" | bc)
pct_int=${pct%.*}
[[ $pct_int -gt 100 ]] && pct="100.0"

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

echo "${pct}% | color=$color sfcolor=$color"
echo "---"
echo "Premium Requests | size=11 color=gray"
echo "$bar ${total_requests}/${PLAN_LIMIT} | font=Menlo size=13 color=$color"
echo "---"
days_left=$(( $(date -v1d -v+1m +%s) - $(date +%s) ))
days_left=$((days_left / 86400))
echo "Resets in $days_left days | size=12 color=gray"
echo "---"
echo "View on GitHub | href=https://github.com/settings/copilot/features"
echo "Refresh | refresh=true"
