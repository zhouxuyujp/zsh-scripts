module.exports = {
  apps: [
    {
      name: 'reboot-server',
      script: '/home/ubuntu/reboot-server.zsh',
      cron_restart: '30 4 * * *',
      autorestart: false
    }
  ]
}
