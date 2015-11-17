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
        switch macAccessoriesCount
          when 1
            params =
              content: 'ｱｲﾃﾑの構造がｶﾜｯﾀ(ｶﾓｼﾚﾅｲ) :eyes:'
              color: 'danger'

          when 2
            params =
              content: "ﾏﾀﾞﾀﾞﾖ"
              color: 'warning'

          else
            params =
              channel: "@#{process.env.HUBOT_SLACK_MASTER}"
              content: """
                <@#{process.env.HUBOT_SLACK_MASTER}>
                <#{@apple.url}#{@apple.macAccessoriesPrefix}|整備済み Time Capsule> ｷﾃﾙﾖ :+1:
              """

        @incomingWebhook.notify params, callback

    ], (err, result) ->
      if err
        params =
          text: err.stack
          color: 'danger'
        return @incomingWebhook.notify params
