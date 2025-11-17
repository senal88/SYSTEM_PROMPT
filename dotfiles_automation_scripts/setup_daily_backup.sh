#!/bin/bash
# Schedule daily backup at 2AM using launchd
PLIST_FILE=~/Library/LaunchAgents/com.luiz.dailybackup.plist

cat <<EOF > "$PLIST_FILE"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.luiz.dailybackup</string>
    <key>ProgramArguments</key>
    <array>
        <string>$DOTFILES_HOME/create_backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
EOF

launchctl load "$PLIST_FILE"
echo "Daily backup scheduled."
