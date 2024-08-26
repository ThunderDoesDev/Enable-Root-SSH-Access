# Enable Root SSH Access Script

This repository contains scripts designed to enable root login via SSH on a Linux server. The scripts update the SSH configuration to allow root login and password authentication, prompt the user to set the root password, restart the SSH service, and then delete themselves after successful execution.

## Available Scripts

- **Bash (`enable_root.sh`)**: Original script written in Bash.
- **Python (`enable_root.py`)**: Python version of the script.
- **Node.js (`enable_root.js`)**: Node.js version of the script.

## Features

- **PermitRootLogin**: Enables `PermitRootLogin` in the SSH configuration to allow root login.
- **PasswordAuthentication**: Enables `PasswordAuthentication` in the SSH configuration to allow password-based SSH access.
- **Root Password Setup**: Prompts the user to set a new root password.
- **Service Detection and Restart**: Automatically detects and restarts the appropriate SSH service (`sshd` or `ssh`).
- **Self-Deletion**: Deletes the script after successful execution to prevent unauthorized reuse.

## Requirements

- **Supported Linux Distributions**: 
  - CentOS
  - Debian
  - Ubuntu
  - Fedora
  - Arch Linux
  - SUSE
  - Other similar distributions
- **Privileges**: 
  - The script must be run with sudo or root privileges to modify SSH configurations and restart services.

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/ThunderDoesDev/Enable-Root-SSH-Access.git
   cd Enable-Root-SSH-Access
   ```

2. **Make the Script Executable**:

   - **Bash**: 

     ```bash
     chmod +x enable_root.sh
     ```

   - **Python**:

     ```bash
     chmod +x enable_root.py
     ```

   - **Node.js**:

     ```bash
     chmod +x enable_root.js
     ```

## Usage

### Bash Version

1. **Run the Script**:

    ```bash
    sudo ./enable_root.sh
    ```

2. **Script Execution**:

    - The script will modify the SSH configuration to allow root login and password authentication.
    - You will be prompted to set a new root password.
    - The script will automatically detect and restart the appropriate SSH service (`sshd` or `ssh`).
    - After successful execution, the script will delete itself.

### Python Version

1. **Install Python** (if not already installed):

   ```bash
   sudo apt-get install python3
   ```

2. **Run the Script**:

    ```bash
    sudo ./enable_root.py
    ```

3. **Script Execution**:

    - The script will modify the SSH configuration to allow root login and password authentication.
    - You will be prompted to set a new root password.
    - The script will automatically detect and restart the appropriate SSH service (`sshd` or `ssh`).
    - After successful execution, the script will delete itself.

### Node.js Version

1. **Install Node.js** (if not already installed):

   ```bash
   sudo apt-get install nodejs
   ```

2. **Run the Script**:

    ```bash
    sudo ./enable_root.js
    ```

3. **Script Execution**:

    - The script will modify the SSH configuration to allow root login and password authentication.
    - You will be prompted to set a new root password.
    - The script will automatically detect and restart the appropriate SSH service (`sshd` or `ssh`).
    - After successful execution, the script will delete itself.

## Security Considerations

- **Warning**: Enabling root login via SSH is a significant security risk, especially in production environments. It is strongly recommended to disable root login after performing necessary administrative tasks.
- **Post-Usage**: Consider reverting the changes made by this script once you no longer need root SSH access to enhance server security.

## Troubleshooting

- **Service Restart Issues**: If the script fails to restart the SSH service, ensure that the correct SSH service is installed and running (`sshd` or `ssh`). You can check the service status using:
  
  ```bash
  sudo systemctl status sshd
  sudo systemctl status ssh
  ```

- **Configuration Check**: Verify that the changes were applied correctly by inspecting the SSH configuration file at `/etc/ssh/sshd_config`. Ensure that the following lines are set:

  ```bash
  PermitRootLogin yes
  PasswordAuthentication yes
  ```

## License

This project is licensed under the APACHE License. See the [LICENSE](LICENSE) file for more details.

## Support

For support, issues, or enhancements, please open an issue in this repository or join our Discord support server.

[Join Support Server](https://discord.gg/thunderdoesdev)

---

**Disclaimer**: This script is provided "as is" without any warranties or guarantees. By using this script, you agree to take full responsibility for any security implications that may arise from enabling root login via SSH on your server.

---