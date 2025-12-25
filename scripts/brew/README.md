# Brew Backup Script

Automates backup of all Homebrew formulas & casks to a CSV file.  
Runs daily at 8pm and at system startup, using a macOS Launch Agent.

## How it works

- Uses a launch agent (`plist`) to schedule and run the script in the background.
- Script saves backup at: `~/backup/brew/brew_backup.csv`
- Only one backup per day is created.

## Setup

1. Place `brew-backup.sh` wherever you want.
2. Make the script executable:
   ```sh
   chmod +x /path/to/brew-backup.sh
   ```
3. Edit the provided `.plist` file—set the full script path.
4. Move plist to `~/Library/LaunchAgents/`.
5. Load agent:
   ```sh
   launchctl load ~/Library/LaunchAgents/com.peakmac.brewbackup.plist
   ```

## Requirements

- **Terminal access**
- **Homebrew installed**
- **System permissions** to run scripts in the background (see below for Mac system setting).

---

## Allow “zsh” automation in System Settings

Make sure to allow **zsh** to run as an extension (otherwise script may not run automatically):

![script](https://raw.githubusercontent.com/69-PEAK/dotfiles/main/images/readme/brew-script.png)

---

If the script doesn't run as expected, check these log files for errors:

- `/Users/peakmac/Library/Logs/brewbackup.log`
- `/Users/peakmac/Library/Logs/brewbackup.error.log`
