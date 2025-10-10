# Omarchy-Style SketchyBar Configuration

This is an Omarchy Linux waybar-inspired configuration for SketchyBar on macOS.

## Features

### Design
- **Catppuccin Mocha** color scheme
- **Semi-transparent bar** with blur effect
- **Rounded module backgrounds** (pill-shaped)
- **Centered workspaces** (AeroSpace integration)
- **Minimal, clean aesthetic**

### Modules

#### Left Side
- Clean, minimal (no Apple menu in Omarchy style)

#### Center
- **Workspaces**: Shows AeroSpace workspaces with active highlighting
  - Inactive workspaces: subtle gray
  - Active workspace: lavender highlight with brighter background

#### Right Side (left to right)
- **Wi-Fi**: Shows SSID with connection status
  - Click: Opens Network Settings
  - Right-click: Toggles Wi-Fi on/off
  
- **Volume**: Shows volume percentage with icon
  - Click: Mute/unmute
  - Auto-updates on volume changes
  
- **Battery**: Shows battery percentage with charging status
  - Different icons for battery levels
  - Green when charging
  - Red when low (<20%)
  
- **Clock**: Shows day, date, and time
  - Format: "Mon 10 Oct 16:22"
  - Click: Opens Calendar

## Color Scheme

Based on Catppuccin Mocha palette:
- Bar background: Semi-transparent base (`#1e1e2e` with 81% opacity)
- Module backgrounds: Surface0 (`#313244`)
- Active module backgrounds: Surface1 (`#45475a`)
- Text: Catppuccin Text (`#cdd6f4`)
- Accents: Various Catppuccin colors (Lavender, Blue, Sky, Green, etc.)

## Requirements

- SketchyBar
- AeroSpace (for workspace management)
- Nerd Fonts (for icons)
- SF Pro font (default on macOS)

## Installation

The configuration is located in `~/.config/sketchybar/` (or wherever you've symlinked it).

After making changes, reload SketchyBar:
```bash
brew services restart sketchybar
```

Or:
```bash
sketchybar --reload
```

## File Structure

```
sketchybar/
├── sketchybarrc          # Main configuration
├── colors.sh             # Catppuccin Mocha color definitions
├── icons.sh              # Icon definitions (Nerd Fonts)
├── items/                # Module configurations
│   ├── spaces.sh         # Workspace module
│   ├── wifi.sh           # Wi-Fi module
│   ├── volume.sh         # Volume module
│   ├── battery.sh        # Battery module
│   └── calendar.sh       # Clock/calendar module
└── plugins/              # Plugin scripts
    ├── aerospacer.sh     # Workspace highlighting
    ├── wifi.sh           # Wi-Fi status script
    ├── volume.sh         # Volume control script
    ├── battery.sh        # Battery status script
    └── clock.sh          # Clock/date script
```

## Customization

### Changing Colors
Edit `colors.sh` to modify the color scheme. All colors use the format `0xAARRGGBB` where:
- `AA` = alpha (transparency)
- `RR` = red
- `GG` = green
- `BB` = blue

### Adjusting Module Appearance
Edit the respective files in `items/` to change:
- Font sizes
- Padding
- Corner radius
- Background colors

### Module Order
Edit `sketchybarrc` to change which modules are loaded and their position (`left`, `center`, or `right`).

## Differences from Original Waybar (Omarchy)

Some features from the original Omarchy waybar that work differently on macOS:
- No system tray (macOS handles this differently)
- Battery uses macOS `pmset` instead of `/sys/class/power_supply`
- Wi-Fi uses macOS `networksetup` instead of `nmcli`
- Volume uses AppleScript instead of PulseAudio/PipeWire
- Workspaces use AeroSpace instead of Hyprland

## Troubleshooting

### Icons not showing
Make sure you have Nerd Fonts installed. You can install them via:
```bash
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```

### Modules not updating
Check that all plugin scripts are executable:
```bash
chmod +x ~/.config/sketchybar/plugins/*.sh
```

### Bar not appearing
Restart SketchyBar:
```bash
brew services restart sketchybar
```
