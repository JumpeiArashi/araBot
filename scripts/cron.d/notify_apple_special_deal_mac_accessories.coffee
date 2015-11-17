{CronJob} = require 'cron'

Controller = require '../controllers/notify_apple_special_deal_mac_accessories'

new CronJob
  cronTime: '00 * * * * *'
  onTick: ->
    controller = new Controller()
    controller.execute()
  start: true
  timeZone: 'Asia/Tokyo'
