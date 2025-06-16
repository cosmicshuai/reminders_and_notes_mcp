#!/bin/bash

# Shell wrapper script for adding reminders
# Makes it easier to call the AppleScript from command line or other scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLESCRIPT_PATH="$SCRIPT_DIR/add_reminder_advanced.applescript"

# Function to display usage
usage() {
    echo "Usage: $0 \"title\" [\"description\"] [\"YYYY-MM-DD\"] [\"HH:MM\"] [\"list_name\"]"
    echo ""
    echo "Examples:"
    echo "  $0 \"Buy groceries\""
    echo "  $0 \"Meeting with John\" \"Discuss project timeline\""
    echo "  $0 \"Doctor appointment\" \"Annual checkup\" \"2025-06-20\""
    echo "  $0 \"Team meeting\" \"Weekly standup\" \"2025-06-20\" \"14:30\""
    echo "  $0 \"Workout\" \"Gym session\" \"2025-06-20\" \"18:00\" \"Personal\""
    echo ""
    echo "Parameters:"
    echo "  title       - Required. The title of the reminder"
    echo "  description - Optional. Description/notes for the reminder"
    echo "  date        - Optional. Due date in YYYY-MM-DD format"
    echo "  time        - Optional. Due time in HH:MM format (24-hour)"
    echo "  list_name   - Optional. Name of the Reminders list to add to"
    exit 1
}

# Check if at least title is provided
if [ $# -lt 1 ]; then
    echo "Error: At least a title is required."
    usage
fi

# Check if AppleScript file exists
if [ ! -f "$APPLESCRIPT_PATH" ]; then
    echo "Error: AppleScript file not found at $APPLESCRIPT_PATH"
    exit 1
fi

# Execute the AppleScript with all provided arguments
osascript "$APPLESCRIPT_PATH" "$@"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "✅ Reminder added successfully!"
else
    echo "❌ Failed to add reminder."
    exit 1
fi
