# Enable Root SSH Access Script

This script, `enable_root.sh`, is designed to enable root login via SSH on a Linux server. It updates the SSH configuration to allow root login and password authentication, sets the root password, restarts the SSH service, and then deletes itself.

## Features

- Enables `PermitRootLogin` in SSH configuration.
- Enables `PasswordAuthentication` in SSH configuration.
- Prompts the user to set a root password.
- Automatically detects and restarts the correct SSH service (`sshd` or `ssh`).
- Deletes itself after successful execution.

## Requirements

- **Linux Distribution**: CentOS, Debian, Ubuntu, Fedora, Arch Linux, SUSE, or other similar distributions.
- **Privileges**: The script must be run with sudo privileges to modify the SSH configuration and restart services.

## Installation

1. **Download the Script**: Clone the repository or download the script directly.

    ```bash
    git clone https://github.com/yourusername/yourrepository.git
    cd yourrepository
    ```

    Alternatively, download it directly:

    ```bash
    wget https://raw.githubusercontent.com/yourusername/yourrepository/main/enable_root.sh
    ```

2. **Make the Script Executable**:

    ```bash
    chmod +x enable_root.sh
    ```

## Usage

1. **Run the Script**:

    Execute the script to enable root SSH access.

    ```bash
    sudo ./enable_root.sh
    ```

2. **Script Execution**:

    - The script will update the SSH configuration to allow root login.
    - You will be prompted to set a new root password.
    - The script will detect and restart the correct SSH service (`sshd` or `ssh`).
    - After successful execution, the script will delete itself.

## Important Notes

- **Security Consideration**: Enabling root login via SSH is not recommended for production environments due to security risks. Use this script only if necessary, and consider disabling root login afterward.
- **Post-Usage Cleanup**: The script automatically deletes itself after execution to prevent unauthorized reuse.

## Troubleshooting

- If the script fails to restart the SSH service, ensure that the correct service is installed and running on your system.
- Check the SSH configuration file at `/etc/ssh/sshd_config` to ensure changes were applied correctly.

## License

This project is licensed under the APACHE License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to suggest improvements or report bugs.

## Contact

For any questions or support, please open an issue in this repository.

---

**Disclaimer**: Use this script at your own risk. Ensure you understand the security implications of enabling root login via SSH on your server.
