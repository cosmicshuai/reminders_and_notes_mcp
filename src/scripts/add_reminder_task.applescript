-- AppleScript to add a task to Reminders app
-- Parameters: title, description, due date, due time
-- Usage example: 
-- osascript add_reminder_task.applescript "Meeting with John" "Discuss project timeline" "2025-06-20" "14:30"

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
    
    -- Get description if provided
    if (count of argv) >= 2 then
        set taskDescription to item 2 of argv
    end if
    x
    -- Get due date if provided
    if (count of argv) >= 3 then
        set dueDateString to item 3 of argv
        try
            set dueDate to date dueDateString
        on error
            display dialog "Error: Invalid date format. Please use YYYY-MM-DD format." buttons {"OK"} default button "OK"
            return
        end try
    end if
    
    -- Get due time if provided and we have a due date
    if (count of argv) >= 4 and dueDate is not missing value then
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
    
    -- Add the reminder to the default list
    tell application "Reminders"
        -- Create new reminder in the default list
        set defaultList to default list
        set newReminder to make new reminder at end of reminders of defaultList
        
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
        if dueDate is not missing value then
            set dueDateFormatted to (short date string of dueDate) & " at " & (time string of dueDate)
            display notification "Reminder added: " & taskTitle with title "Reminders" subtitle "Due: " & dueDateFormatted
        else
            display notification "Reminder added: " & taskTitle with title "Reminders"
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
