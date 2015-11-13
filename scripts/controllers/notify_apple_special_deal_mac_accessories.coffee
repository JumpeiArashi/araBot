Async = require 'async'
AppleSpecialDeal = require '../models/apple_special_deal'
SlackIncomingWebhook = require '../models/slack_incoming_webhook'

module.exports = class NotifyAppleSpecialDealMacAccessories

  constructor: ->
    @incomingWebhook = new SlackIncomingWebhook
      url: process.env.HUBOT_SLACK_INCMOING_WEBHOOK_URL
      title: 'Mac Special Deal -Mac Accessories-'
      color: 'good'

    @apple = new AppleSpecialDeal()

  execute: =>
    Async.waterfall [
      (callback) =>
        @apple.getMacAccessoriesCount callback

      (macAccessoriesCount, callback) =>
        if macAccessoriesCount > 2
          params =
            channel: "@#{process.env.HUBOT_SLACK_MASTER}"
            content: """
              [整備済み Time Capsule](#{@apple.url}#{@apple.macAccessoriesPrefix}) ｷﾃﾙﾖ
            """
          @incomingWebhook.notify params, callback

        # this notify will be removed for days
        else
          params =
            content: "まだだよ"
            color: 'danger'

          @incomingWebhook.notify params, callback
    ], (err, result) ->
      if err
        params =
          text: err.stack
          color: 'danger'
        return @incomingWebhook.notify params
