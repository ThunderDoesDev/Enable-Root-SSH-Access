const assert = require('assert');
const child_process = require('child_process');

// patch execSync before requiring the script so that internal calls use the mock
function withExecSync(mockFn, fn) {
  const original = child_process.execSync;
  child_process.execSync = (...args) => mockFn(...args);
  delete require.cache[require.resolve('../enable_root.js')];
  const script = require('../enable_root.js');
  script.logMessage = () => {};
  try {
    fn(script);
  } finally {
    child_process.execSync = original;
    delete require.cache[require.resolve('../enable_root.js')];
  }
}

function testRestartSshService() {
  let commands = [];
  // sshd active
  withExecSync((cmd) => {
    commands.push(cmd);
    if (cmd.startsWith('systemctl is-active')) {
      if (cmd.includes('sshd')) return ''; // success
      throw new Error('inactive');
    }
    return '';
  }, (script) => {
    script.restartSshService();
  });
  assert(commands.includes('sudo systemctl restart sshd'));

  // ssh active when sshd inactive
  commands = [];
  withExecSync((cmd) => {
    commands.push(cmd);
    if (cmd.startsWith('systemctl is-active')) {
      if (cmd.includes('sshd')) throw new Error('inactive');
      return ''; // ssh active
    }
    return '';
  }, (script) => {
    script.restartSshService();
  });
  assert(commands.includes('sudo systemctl restart ssh'));

  // neither active
  let errorCaught = false;
  withExecSync((cmd) => {
    if (cmd.startsWith('systemctl is-active')) {
      throw new Error('inactive');
    }
  }, (script) => {
    try {
      script.restartSshService();
    } catch (e) {
      errorCaught = true;
    }
  });
  assert(errorCaught, 'Expected error when no SSH service is active');
}

testRestartSshService();
console.log('All tests passed.');
