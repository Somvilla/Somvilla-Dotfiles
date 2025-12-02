#!/bin/bash
# Simple Countdown Timer with Notifications
# Usage: timer.sh [time] [message]
# Examples: timer.sh 5m "Break time"
#          timer.sh 30s
#          timer.sh 1h30m "Meeting"

set -e

# Default values
TIME=""
MESSAGE="Timer finished!"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "Usage: $0 [time] [message]"
            echo "Time formats: 30s, 5m, 1h, 1h30m, 90 (seconds)"
            echo "Examples:"
            echo "  $0 5m"
            echo "  $0 30s \"Break time\""
            echo "  $0 1h30m \"Meeting\""
            exit 0
            ;;
        *)
            if [[ -z "$TIME" ]]; then
                TIME="$1"
            else
                MESSAGE="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$TIME" ]]; then
    echo "Timer - Enter time and optional message"
    echo "Examples: 5m, 30s, 1h30m, 90"
    echo ""
    read -p "Time: " TIME
    if [[ -z "$TIME" ]]; then
        echo "No time entered. Exiting."
        exit 1
    fi
    read -p "Message (optional): " MESSAGE
    if [[ -z "$MESSAGE" ]]; then
        MESSAGE="Timer finished!"
    fi
fi

# Parse time string to seconds
parse_time() {
    local time_str="$1"
    local total_seconds=0

    # Handle formats like 1h30m, 5m, 30s, or just numbers (seconds)
    if [[ $time_str =~ ^([0-9]+)h([0-9]+)m$ ]]; then
        local hours="${BASH_REMATCH[1]}"
        local minutes="${BASH_REMATCH[2]}"
        total_seconds=$((hours * 3600 + minutes * 60))
    elif [[ $time_str =~ ^([0-9]+)h$ ]]; then
        local hours="${BASH_REMATCH[1]}"
        total_seconds=$((hours * 3600))
    elif [[ $time_str =~ ^([0-9]+)m$ ]]; then
        local minutes="${BASH_REMATCH[1]}"
        total_seconds=$((minutes * 60))
    elif [[ $time_str =~ ^([0-9]+)s$ ]]; then
        local seconds="${BASH_REMATCH[1]}"
        total_seconds=$seconds
    elif [[ $time_str =~ ^[0-9]+$ ]]; then
        # Just a number, assume seconds
        total_seconds=$time_str
    else
        echo "Error: Invalid time format. Use formats like: 30s, 5m, 1h, 1h30m, or just numbers for seconds"
        exit 1
    fi

    echo $total_seconds
}

# Format seconds to readable time
format_time() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))

    if [[ $hours -gt 0 ]]; then
        printf "%02d:%02d:%02d" $hours $minutes $secs
    else
        printf "%02d:%02d" $minutes $secs
    fi
}

# Main countdown function
countdown() {
    local total_seconds=$(parse_time "$TIME")
    local current_seconds=$total_seconds

    echo "Timer started: $(format_time $total_seconds) - $MESSAGE"
    echo "Press Ctrl+C to cancel"

    while [[ $current_seconds -gt 0 ]]; do
        printf "\rTime remaining: %s " "$(format_time $current_seconds)"
        sleep 1
        ((current_seconds--))
    done

    printf "\rTime remaining: %s \n" "$(format_time 0)"
}

# Send notification
send_notification() {
    local title="⏰ Timer Finished"
    local body="$MESSAGE"

    # Try dunstify first (used in other scripts)
    if command -v dunstify &> /dev/null; then
        dunstify -a "Timer" -u critical "$title" "$body"
    # Fallback to notify-send
    elif command -v notify-send &> /dev/null; then
        notify-send -u critical "$title" "$body"
    else
        echo "Warning: No notification system found"
    fi

    # Try to play a sound if available
    if command -v paplay &> /dev/null && [[ -f /usr/share/sounds/freedesktop/stereo/complete.oga ]]; then
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
    elif command -v aplay &> /dev/null && [[ -f /usr/share/sounds/alsa/Front_Center.wav ]]; then
        aplay /usr/share/sounds/alsa/Front_Center.wav &
    fi

    echo ""
    echo "🔔 $title"
    echo "$body"
}

# Trap Ctrl+C to show cancellation message
trap 'echo -e "\nTimer cancelled."; exit 0' INT

# Run countdown and notification
countdown
send_notification