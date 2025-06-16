#!/usr/bin/env python3
"""
Handlers for the Reminders and Notes MCP server.
This module provides functions to interact with the reminder scripts.
"""

import subprocess
import os
from typing import Optional
from datetime import datetime


def add_reminder(
    title: str,
    description: Optional[str] = None,
    due_date: Optional[str] = None,
    due_time: Optional[str] = None,
    list_name: Optional[str] = None
) -> dict:
    """
    Add a reminder using the add_reminder.sh script.
    
    Args:
        title (str): The title of the reminder (required)
        description (str, optional): Description/notes for the reminder
        due_date (str, optional): Due date in YYYY-MM-DD format
        due_time (str, optional): Due time in HH:MM format (24-hour)
        list_name (str, optional): Name of the Reminders list to add to
    
    Returns:
        dict: Result of the operation with success status and message
        
    Raises:
        ValueError: If required parameters are missing or invalid
        FileNotFoundError: If the script file is not found
        subprocess.CalledProcessError: If the script execution fails
    """
    
    # Validate required parameters
    if not title or not title.strip():
        raise ValueError("Title is required and cannot be empty")
    
    # Validate date format if provided
    if due_date:
        try:
            datetime.strptime(due_date, "%Y-%m-%d")
        except ValueError:
            raise ValueError("Due date must be in YYYY-MM-DD format")
    
    # Validate time format if provided
    if due_time:
        try:
            datetime.strptime(due_time, "%H:%M")
        except ValueError:
            raise ValueError("Due time must be in HH:MM format (24-hour)")
    
    # Get the script path relative to this file
    current_dir = os.path.dirname(os.path.abspath(__file__))
    script_path = os.path.join(current_dir, "..", "scripts", "add_reminder.sh")
    script_path = os.path.abspath(script_path)
    
    # Check if script exists
    if not os.path.exists(script_path):
        raise FileNotFoundError(f"Script not found at: {script_path}")
    
    # Prepare command arguments
    cmd = [script_path, title]
    
    # Add optional parameters in order
    if description:
        cmd.append(description)
    elif due_date or due_time or list_name:
        cmd.append("")  # Empty description placeholder
    
    if due_date:
        cmd.append(due_date)
    elif due_time or list_name:
        cmd.append("")  # Empty date placeholder
    
    if due_time:
        cmd.append(due_time)
    elif list_name:
        cmd.append("")  # Empty time placeholder
    
    if list_name:
        cmd.append(list_name)
    
    try:
        # Execute the script
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True
        )
        
        return {
            "success": True,
            "message": result.stdout.strip(),
            "title": title,
            "description": description,
            "due_date": due_date,
            "due_time": due_time,
            "list_name": list_name
        }
        
    except subprocess.CalledProcessError as e:
        return {
            "success": False,
            "message": f"Script execution failed: {e.stderr.strip() if e.stderr else str(e)}",
            "error_code": e.returncode
        }
    except Exception as e:
        return {
            "success": False,
            "message": f"Unexpected error: {str(e)}"
        }


def add_simple_reminder(title: str, list_name: Optional[str] = None) -> dict:
    """
    Add a simple reminder with just a title and optional list name.
    
    Args:
        title (str): The title of the reminder
        list_name (str, optional): Name of the Reminders list to add to
    
    Returns:
        dict: Result of the operation
    """
    return add_reminder(title=title, list_name=list_name)


def add_reminder_with_date(
    title: str,
    due_date: str,
    description: Optional[str] = None,
    list_name: Optional[str] = None
) -> dict:
    """
    Add a reminder with a due date.
    
    Args:
        title (str): The title of the reminder
        due_date (str): Due date in YYYY-MM-DD format
        description (str, optional): Description/notes for the reminder
        list_name (str, optional): Name of the Reminders list to add to
    
    Returns:
        dict: Result of the operation
    """
    return add_reminder(
        title=title,
        description=description,
        due_date=due_date,
        list_name=list_name
    )


def add_reminder_with_datetime(
    title: str,
    due_date: str,
    due_time: str,
    description: Optional[str] = None,
    list_name: Optional[str] = None
) -> dict:
    """
    Add a reminder with both due date and time.
    
    Args:
        title (str): The title of the reminder
        due_date (str): Due date in YYYY-MM-DD format
        due_time (str): Due time in HH:MM format (24-hour)
        description (str, optional): Description/notes for the reminder
        list_name (str, optional): Name of the Reminders list to add to
    
    Returns:
        dict: Result of the operation
    """
    return add_reminder(
        title=title,
        description=description,
        due_date=due_date,
        due_time=due_time,
        list_name=list_name
    )


# Example usage and testing functions
if __name__ == "__main__":
    # Test the functions
    print("Testing reminder functions...")
    
    # Test simple reminder
    result = add_simple_reminder("Test reminder from Python")
    print(f"Simple reminder result: {result}")
    
    # Test reminder with date
    result = add_reminder_with_date(
        "Meeting tomorrow",
        "2025-06-16",
        "Important client meeting"
    )
    print(f"Date reminder result: {result}")
    
    # Test full reminder
    result = add_reminder_with_datetime(
        "Doctor appointment",
        "2025-06-20",
        "09:30",
        "Annual checkup",
        "Personal"
    )
    print(f"Full reminder result: {result}")