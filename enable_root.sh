#!/bin/bash

SSH_CONFIG="/etc/ssh/sshd_config"
SCRIPT_PATH=$(realpath "$0")

update_ssh_config() {
    local config_file=$1

    if ! sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$config_file"; then
        printf "Error: Failed to update PermitRootLogin in %s\n" "$config_file" >&2
        return 1
    fi

    if ! sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$config_file"; then
        printf "Error: Failed to update PasswordAuthentication in %s\n" "$config_file" >&2
        return 1
    fi
}

set_root_password() {
    if ! sudo passwd root; then
        printf "Error: Failed to set root password.\n" >&2
        return 1
    fi
}

restart_ssh_service() {
    if systemctl list-units --full -all | grep -qE '^sshd\.service'; then
        if ! sudo systemctl restart sshd; then
            printf "Error: Failed to restart sshd service.\n" >&2
            return 1
        fi
        printf "sshd service restarted successfully.\n"
    elif systemctl list-units --full -all | grep -qE '^ssh\.service'; then
        if ! sudo systemctl restart ssh; then
            printf "Error: Failed to restart ssh service.\n" >&2
            return 1
        fi
        printf "ssh service restarted successfully.\n"
    else
        printf "Error: Neither sshd nor ssh service found on this system.\n" >&2
        return 1
    fi
}

delete_script() {
    if ! rm -f "$SCRIPT_PATH"; then
        printf "Error: Failed to delete the script file at %s\n" "$SCRIPT_PATH" >&2
        return 1
    fi
    printf "Script file %s has been deleted.\n" "$SCRIPT_PATH"
}

main() {
    update_ssh_config "$SSH_CONFIG" || return 1
    set_root_password || return 1
    restart_ssh_service || return 1

    printf "Root login via SSH has been enabled and SSH service restarted.\n"

    delete_script || return 1
}

main "$@"
