# GitHub Copilot Usage Widget for macOS

A SwiftBar/xbar menu bar widget that shows your GitHub Copilot premium request usage.

## Features

- Shows usage percentage in menu bar (color-coded: green → yellow → red)
- Progress bar with requests used/total
- Days until monthly reset
- Quick link to GitHub Copilot settings

## Requirements

- macOS
- [SwiftBar](https://github.com/swiftbar/SwiftBar) or [xbar](https://xbarapp.com/)
- [jq](https://jqlang.github.io/jq/) (`brew install jq`)
- GitHub Personal Access Token with billing permissions

## Installation

### 1. Install SwiftBar and jq

```bash
brew install swiftbar jq
```

### 2. Create a GitHub Personal Access Token

1. Go to [GitHub Token Settings](https://github.com/settings/tokens?type=beta)
2. Click **Generate new token** (Fine-grained)
3. Give it a name like "Copilot Usage Widget"
4. Under **Account permissions**, enable **Plan** → **Read-only**
5. Generate and copy the token

### 3. Configure the Plugin

1. Copy `copilot-spending.15m.sh` to your SwiftBar plugins folder
2. Edit the file and replace:
   - `YOUR_GITHUB_PAT_HERE` with your token
   - `YOUR_GITHUB_USERNAME` with your GitHub username
3. Set `PLAN_LIMIT` based on your plan:
   - Free: `50`
   - Pro: `300`
   - Pro+: `1500`

### 4. Make it Executable

```bash
chmod +x /path/to/plugins/copilot-spending.15m.sh
```

### 5. Refresh SwiftBar

Click the SwiftBar icon → Refresh All

## Refresh Interval

The filename `copilot-spending.15m.sh` sets refresh to every 15 minutes. Rename to change:
- `copilot-spending.5m.sh` → 5 minutes
- `copilot-spending.1h.sh` → 1 hour

## Troubleshooting

**"Setup" showing in menu bar**
- Edit the plugin and set your `GITHUB_TOKEN` and `GITHUB_USERNAME`

**"Err" showing in menu bar**
- Check your token has "Plan" read permission
- Verify your username is correct

**Widget not appearing**
- Ensure SwiftBar is running
- Check the plugin is in your SwiftBar plugins folder
- Verify the file is executable (`chmod +x`)

## License

MIT
