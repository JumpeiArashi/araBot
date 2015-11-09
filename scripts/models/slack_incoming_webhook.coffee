Request = require 'request'

module.exports = class IncomingWebhook

  constructor: ({
    @url
    @title
    @color
    @channel
  }) ->

  notify: (params, callback) =>
    params.title ?= @title
    params.color ?= @color
    params.channel ?= @channel

    attachment =
      attachments: [
        fallback: params.content
        color: params.color
        fields: [
          title: params.title
          value: params.content
        ]
        mrkdwn_in: ['fields']
      ]
      channel: params.channel

    body = JSON.stringify attachment
    options =
      uri: @url
      body: body
    Request.post options, (err, res, body) =>
      if err
        callback err if callback
        return
      callback null, res if callback
