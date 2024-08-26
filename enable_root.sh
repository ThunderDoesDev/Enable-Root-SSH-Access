#!/bin/bash

# Global variables
SSH_CONFIG="/etc/ssh/sshd_config"
SCRIPT_PATH=$(realpath "$0")
LOG_FILE="/var/log/ssh_config_update.log"

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | sudo tee -a "$LOG_FILE"
}

# Function to update SSH configuration
update_ssh_config() {
    local config_file=$1

    if ! sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$config_file"; then
        log_message "Error: Failed to update PermitRootLogin in $config_file"
        return 1
    fi

    if ! sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$config_file"; then
        log_message "Error: Failed to update PasswordAuthentication in $config_file"
        return 1
    fi

    log_message "SSH configuration updated in $config_file"
}

# Function to set root password
set_root_password() {
    if ! sudo passwd root; then
        log_message "Error: Failed to set root password."
        return 1
    fi
    log_message "Root password set successfully."
}

# Function to restart SSH service, checking for sshd or ssh
restart_ssh_service() {
    if sudo systemctl is-active --quiet sshd; then
        if ! sudo systemctl restart sshd; then
            log_message "Error: Failed to restart sshd service."
            return 1
        fi
        log_message "sshd service restarted successfully."
    elif sudo systemctl is-active --quiet ssh; then
        if ! sudo systemctl restart ssh; then
            log_message "Error: Failed to restart ssh service."
            return 1
        fi
        log_message "ssh service restarted successfully."
    else
        log_message "Error: Neither sshd nor ssh service found on this system."
        return 1
    fi
}

# Function to delete the script file
delete_script() {
    if ! rm -f "$SCRIPT_PATH"; then
        log_message "Error: Failed to delete the script file at $SCRIPT_PATH"
        return 1
    fi
    log_message "Script file $SCRIPT_PATH has been deleted."
}

# Main function
main() {
    log_message "Starting SSH configuration update script."
    update_ssh_config "$SSH_CONFIG" || return 1
    set_root_password || return 1
    restart_ssh_service || return 1

    log_message "Root login via SSH has been enabled and SSH service restarted."

    delete_script || return 1
}

main "$@"