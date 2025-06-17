from typing import Any
import httpx
from mcp.server.fastmcp import FastMCP
import sys
import os

# Add the parent directory to the path so we can import from handlers
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from handers.handlers import (
    add_reminder as add_reminder_handler,
    add_simple_reminder,
    add_reminder_with_date,
    add_reminder_with_datetime
)

# Initialize FastMCP server
mcp = FastMCP("reminders_and_notes_server")

@mcp.tool("add_reminder")
async def  add_reminder(
    title: str,
    description: str = "",
    due_date: str = "",
    due_time: str = "",
    list_name: str = "Reminders"
) -> dict:
    """
    Add a reminder with optional due date and time.
    
    Args:
        title (str): The title of the reminder
        description (str, optional): Description/notes for the reminder
        due_date (str, optional): Due date in YYYY-MM-DD format
        due_time (str, optional): Due time in HH:MM format (24-hour)
        list_name (str, optional): Name of the Reminders list to add to
    
    Returns:
        dict: Result of the operation
    """
    try:
        # Convert empty strings to None for optional parameters
        description_param = description if description else None
        due_date_param = due_date if due_date else None
        due_time_param = due_time if due_time else None
        list_name_param = list_name if list_name and list_name != "Reminders" else None
        
        # Call the actual handler function
        result = add_reminder_handler(
            title=title,
            description=description_param,
            due_date=due_date_param,
            due_time=due_time_param,
            list_name=list_name_param
        )
        
        return result
        
    except Exception as e:
        return {
            "success": False,
            "message": f"Error adding reminder: {str(e)}"
        }


