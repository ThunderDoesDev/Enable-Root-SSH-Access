#!/usr/bin/env python3

import subprocess
import os
import sys
import logging
from datetime import datetime

# Global variables
SSH_CONFIG = "/etc/ssh/sshd_config"
SCRIPT_PATH = os.path.realpath(__file__)
LOG_FILE = "/var/log/ssh_config_update.log"

# Configure logging
logging.basicConfig(filename=LOG_FILE, level=logging.INFO, format='%(asctime)s - %(message)s')

def log_message(message):
    logging.info(message)
    print(message)

def run_command(command):
    try:
        subprocess.run(command, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        log_message(f"Error: Command '{command}' failed with exit code {e.returncode}")
        sys.exit(1)

def update_ssh_config(config_file):
    run_command(f"sudo sed -i 's/^#\\?PermitRootLogin.*/PermitRootLogin yes/' {config_file}")
    run_command(f"sudo sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/' {config_file}")
    log_message(f"SSH configuration updated in {config_file}")

def set_root_password():
    run_command("sudo passwd root")
    log_message("Root password set successfully.")

def restart_ssh_service():
    if subprocess.run("sudo systemctl is-active --quiet sshd", shell=True).returncode == 0:
        run_command("sudo systemctl restart sshd")
        log_message("sshd service restarted successfully.")
    elif subprocess.run("sudo systemctl is-active --quiet ssh", shell=True).returncode == 0:
        run_command("sudo systemctl restart ssh")
        log_message("ssh service restarted successfully.")
    else:
        log_message("Error: Neither sshd nor ssh service found on this system.")
        sys.exit(1)

def delete_script():
    try:
        os.remove(SCRIPT_PATH)
        log_message(f"Script file {SCRIPT_PATH} has been deleted.")
    except Exception as e:
        log_message(f"Error: Failed to delete the script file at {SCRIPT_PATH} - {str(e)}")
        sys.exit(1)

def main():
    log_message("Starting SSH configuration update script.")
    update_ssh_config(SSH_CONFIG)
    set_root_password()
    restart_ssh_service()
    log_message("Root login via SSH has been enabled and SSH service restarted.")
    delete_script()

if __name__ == "__main__":
    main()