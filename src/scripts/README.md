# Reminder and Notes MCP Scripts

This directory contains AppleScript files for adding tasks to the macOS Reminders app.

## Files

- `add_reminder_task.applescript` - Basic AppleScript for adding reminders
- `add_reminder_advanced.applescript` - Advanced version with list selection support
- `add_reminder.sh` - Shell wrapper script for easier command-line usage

## Usage

### Using AppleScript directly

#### Basic version:
```bash
osascript add_reminder_task.applescript "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30"
```

#### Advanced version (with list support):
```
zsh osascript add_reminder_advanced.applescript "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30" "Work"
```

### Using the shell wrapper:
```bash add_reminder.sh "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30" "Work"
```

## Parameters

1. **Title** (required) - The title of the reminder
2. **Description** (optional) - Additional notes or description
3. **Due Date** (optional) - Date in YYYY-MM-DD format
4. **Due Time** (optional) - Time in HH:MM format (24-hour), only used if due date is provided
5. **List Name** (optional, advanced version only) - Name of the Reminders list to add to

## Examples

### Simple reminder with just a title:
```bash
./add_reminder.sh "Buy groceries"
```

### Reminder with description:
```bash
./add_reminder.sh "Doctor appointment" "Annual checkup"
```

### Reminder with due date:
```bash
./add_reminder.sh "Submit report" "Quarterly financial report" "2025-06-25"
```

### Reminder with due date and time:
```bash
./add_reminder.sh "Team meeting" "Weekly standup" "2025-06-20" "14:30"
```

### Reminder in a specific list:
```bash
./add_reminder.sh "Workout" "Gym session" "2025-06-20" "18:00" "Personal"
```

## Features

- **Error handling**: Validates date and time formats
- **List management**: Can create new lists if they don't exist (advanced version)
- **Notifications**: Shows success notifications when reminders are added
- **Flexible parameters**: All parameters except title are optional
- **Default list support**: Uses the default Reminders list if no specific list is provided

## Requirements

- macOS with Reminders app
- AppleScript support (built into macOS)
- Bash shell (for the wrapper script)

## Permissions

The first time you run these scripts, macOS may ask for permission to access the Reminders app. Make sure to grant this permission for the scripts to work properly.

## Notes

- Date format must be YYYY-MM-DD (e.g., "2025-06-20")
- Time format must be HH:MM in 24-hour format (e.g., "14:30" for 2:30 PM)
- If a list name is provided but doesn't exist, the advanced script will offer to create it
- Empty parameters can be passed as empty strings "" to skip optional parameters while providing later ones
