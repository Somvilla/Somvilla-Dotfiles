#!/bin/bash
# Waybar custom module for monitoring and toggling a WireGuard interface

set -euo pipefail

IFACE=${WIREGUARD_INTERFACE:-wg0}
WG_SHOW_CMD=${WIREGUARD_SHOW_CMD:-$(command -v wg 2>/dev/null || echo "")}
WG_QUICK_BIN=${WIREGUARD_QUICK_BIN:-$(command -v wg-quick 2>/dev/null || echo /usr/bin/wg-quick)}
REFRESH_SIGNAL=${WIREGUARD_SIGNAL:-8}

# Decide which privilege helper to use. Prefer sudo when available so users can
# grant passwordless access via sudoers without needing a running polkit agent.
if [[ -n "${WIREGUARD_PKEXEC:-}" ]]; then
    PKEXEC_BIN=${WIREGUARD_PKEXEC}
else
    if command -v sudo >/dev/null 2>&1; then
        PKEXEC_BIN=$(command -v sudo)
    elif command -v pkexec >/dev/null 2>&1; then
        PKEXEC_BIN=$(command -v pkexec)
    else
        PKEXEC_BIN=""
    fi
fi

if [[ -n "$PKEXEC_BIN" && ! -x "$PKEXEC_BIN" ]]; then
    PKEXEC_BIN=""
fi

PKEXEC_ARGS=()
if [[ -n "$PKEXEC_BIN" && $(basename "$PKEXEC_BIN") == "sudo" ]]; then
    PKEXEC_ARGS=(-n)
fi

iface_up() {
    [[ -d "/sys/class/net/$IFACE" ]]
}

current_status() {
    if [[ -n "$WG_SHOW_CMD" ]] && "$WG_SHOW_CMD" show "$IFACE" &>/dev/null; then
        echo "up"
    elif iface_up; then
        echo "up"
    else
        echo "down"
    fi
}

status="$(current_status)"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$1" "$2"
    fi
}

if [[ "${1:-}" == "toggle" ]]; then
    if [[ $status == "up" ]]; then
        action="down"
    else
        action="up"
    fi

    if [[ -z "$PKEXEC_BIN" ]]; then
        notify "WireGuard" "No privilege escalation helper configured"
        exit 1
    fi

    toggle_cmd=("$PKEXEC_BIN" "${PKEXEC_ARGS[@]}" "$WG_QUICK_BIN" "$action" "$IFACE")

    if "${toggle_cmd[@]}"; then
        status="$(current_status)"
        human_action=$([[ $status == "up" ]] && echo "connected" || echo "disconnected")
        notify "WireGuard" "$IFACE $human_action"
        pkill -RTMIN+$REFRESH_SIGNAL waybar 2>/dev/null || true
        exit 0
    else
        notify "WireGuard" "Failed to ${action} $IFACE"
        pkill -RTMIN+$REFRESH_SIGNAL waybar 2>/dev/null || true
        exit 1
    fi
fi

status="$(current_status)"

if [[ $status == "up" ]]; then
    icon=""
    alt="connected"
    tooltip="WireGuard $IFACE connected"
    class="connected"
else
    icon=""
    alt="disconnected"
    tooltip="WireGuard $IFACE disconnected"
    class="disconnected"
fi

printf '{"text":"%s VPN","tooltip":"%s","alt":"%s","class":["wireguard","%s"]}\n' "$icon" "$tooltip" "$alt" "$class"
