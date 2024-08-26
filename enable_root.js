#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const process = require('process');

const SSH_CONFIG = '/etc/ssh/sshd_config';
const SCRIPT_PATH = path.resolve(__filename);
const LOG_FILE = '/var/log/ssh_config_update.log';

function logMessage(message) {
    const timestamp = new Date().toISOString().replace(/T/, ' ').replace(/\..+/, '');
    fs.appendFileSync(LOG_FILE, `${timestamp} - ${message}\n`);
    console.log(message);
}

function runCommand(command) {
    try {
        execSync(command, { stdio: 'inherit' });
    } catch (error) {
        logMessage(`Error: Command '${command}' failed with exit code ${error.status}`);
        process.exit(1);
    }
}

function updateSshConfig(configFile) {
    runCommand(`sudo sed -i 's/^#\\?PermitRootLogin.*/PermitRootLogin yes/' ${configFile}`);
    runCommand(`sudo sed -i 's/^#\\?PasswordAuthentication.*/PasswordAuthentication yes/' ${configFile}`);
    logMessage(`SSH configuration updated in ${configFile}`);
}

function setRootPassword() {
    runCommand('sudo passwd root');
    logMessage('Root password set successfully.');
}

function restartSshService() {
    try {
        runCommand('sudo systemctl restart sshd');
        logMessage('sshd service restarted successfully.');
    } catch {
        try {
            runCommand('sudo systemctl restart ssh');
            logMessage('ssh service restarted successfully.');
        } catch {
            logMessage('Error: Neither sshd nor ssh service found on this system.');
            process.exit(1);
        }
    }
}

function deleteScript() {
    try {
        fs.unlinkSync(SCRIPT_PATH);
        logMessage(`Script file ${SCRIPT_PATH} has been deleted.`);
    } catch (error) {
        logMessage(`Error: Failed to delete the script file at ${SCRIPT_PATH} - ${error.message}`);
        process.exit(1);
    }
}

function main() {
    logMessage('Starting SSH configuration update script.');
    updateSshConfig(SSH_CONFIG);
    setRootPassword();
    restartSshService();
    logMessage('Root login via SSH has been enabled and SSH service restarted.');
    deleteScript();
}

main();