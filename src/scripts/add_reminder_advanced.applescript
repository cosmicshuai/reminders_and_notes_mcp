-- Advanced AppleScript to add a task to Reminders app
-- Parameters: title, description, due date, due time, list name (optional)
-- Usage examples:
-- osascript add_reminder_advanced.applescript "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30"
-- osascript add_reminder_advanced.applescript "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30" "Work"

on run argv
    -- Check if we have the minimum required parameters
    if (count of argv) < 1 then
        display dialog "Error: At least a title is required." buttons {"OK"} default button "OK"
        return
    end if
    
    -- Extract parameters
    set taskTitle to item 1 of argv
    
    -- Set default values for optional parameters
    set taskDescription to ""
    set dueDate to missing value
    set dueTime to missing value
    set listName to ""
    
    -- Get description if provided
    if (count of argv) >= 2 then
        set taskDescription to item 2 of argv
    end if
    
    -- Get due date if provided
    if (count of argv) >= 3 and item 3 of argv is not "" then
        set dueDateString to item 3 of argv
        try
            -- Parse YYYY-MM-DD format
            set dateComponents to my splitString(dueDateString, "-")
            if (count of dateComponents) = 3 then
                set yearNum to (item 1 of dateComponents) as integer
                set monthNum to (item 2 of dateComponents) as integer
                set dayNum to (item 3 of dateComponents) as integer
                
                -- Validate date components
                if yearNum >= 1900 and yearNum <= 2100 and monthNum >= 1 and monthNum <= 12 and dayNum >= 1 and dayNum <= 31 then
                    -- Create a proper date object
                    set dueDate to current date
                    set year of dueDate to yearNum
                    set month of dueDate to monthNum
                    set day of dueDate to dayNum
                    set time of dueDate to 0 -- Start with midnight, will be adjusted if time is provided
                else
                    display dialog "Error: Invalid date values. Year must be 1900-2100, month 1-12, day 1-31." buttons {"OK"} default button "OK"
                    return
                end if
            else
                display dialog "Error: Invalid date format. Please use YYYY-MM-DD format." buttons {"OK"} default button "OK"
                return
            end if
        on error
            display dialog "Error: Invalid date format. Please use YYYY-MM-DD format." buttons {"OK"} default button "OK"
            return
        end try
    end if
    
    -- Get due time if provided and we have a due date
    if (count of argv) >= 4 and item 4 of argv is not "" and dueDate is not missing value then
        set dueTimeString to item 4 of argv
        try
            -- Parse time string (HH:MM format expected)
            set timeComponents to my splitString(dueTimeString, ":")
            if (count of timeComponents) = 2 then
                set hours to (item 1 of timeComponents) as integer
                set minutes to (item 2 of timeComponents) as integer
                
                -- Validate time values
                if hours >= 0 and hours <= 23 and minutes >= 0 and minutes <= 59 then
                    -- Set the time on the due date
                    set time of dueDate to hours * 3600 + minutes * 60
                else
                    display dialog "Error: Invalid time. Hours must be 0-23, minutes must be 0-59." buttons {"OK"} default button "OK"
                    return
                end if
            else
                display dialog "Error: Invalid time format. Please use HH:MM format (24-hour)." buttons {"OK"} default button "OK"
                return
            end if
        on error
            display dialog "Error: Invalid time format. Please use HH:MM format (24-hour)." buttons {"OK"} default button "OK"
            return
        end try
    end if
    
    -- Get list name if provided
    if (count of argv) >= 5 then
        set listName to item 5 of argv
    end if
    
    -- Add the reminder
    tell application "Reminders"
        -- Find the target list
        set targetList to missing value
        
        if listName is not "" then
            -- Try to find the specified list
            try
                set targetList to list listName
            on error
                -- List doesn't exist, ask user if they want to create it
                set response to display dialog "List '" & listName & "' does not exist. Would you like to create it?" buttons {"Cancel", "Create"} default button "Create"
                if button returned of response is "Create" then
                    set targetList to make new list with properties {name:listName}
                else
                    return
                end if
            end try
        else
            -- Use default list
            set targetList to default list
        end if
        
        -- Create new reminder in the target list
        set newReminder to make new reminder at end of reminders of targetList
        
        -- Set the basic properties
        set name of newReminder to taskTitle
        
        -- Set description if provided
        if taskDescription is not "" then
            set body of newReminder to taskDescription
        end if
        
        -- Set due date if provided
        if dueDate is not missing value then
            set due date of newReminder to dueDate
        end if
        
        -- Show success message
        set listDisplayName to name of targetList
        if dueDate is not missing value then
            set dueDateFormatted to (short date string of dueDate) & " at " & (time string of dueDate)
            display notification "Reminder added to " & listDisplayName & ": " & taskTitle with title "Reminders" subtitle "Due: " & dueDateFormatted
        else
            display notification "Reminder added to " & listDisplayName & ": " & taskTitle with title "Reminders"
        end if
    end tell
end run

-- Helper function to split string by delimiter
on splitString(theString, theDelimiter)
    set oldDelimiters to AppleScript's text item delimiters
    set AppleScript's text item delimiters to theDelimiter
    set theArray to every text item of theString
    set AppleScript's text item delimiters to oldDelimiters
    return theArray
end splitString
