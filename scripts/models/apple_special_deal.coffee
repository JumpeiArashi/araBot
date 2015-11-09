Async = require 'async'
Nightmare = require 'nightmare'

module.exports = class AppleSpecialDeal

  constructor: (
    @url = 'http://www.apple.com/jp/shop/browse/home/specialdeals/'
  ) ->

  getMacAccessoriesCount: (callback) =>
    prefix = 'mac/mac_accessories'
    url = "#{@url}#{prefix}"
    macAccessoriesCount = undefined

    nightmare = new Nightmare(
      weak: false
    )
    nightmare
      .goto url
      .wait()
      .evaluate(
        () ->
          itemDoms = document
            .querySelectorAll '#primary .box-content table'
          if itemDoms
            return itemDoms.length
          else
            return null

        (itemCount) ->
          macAccessoriesCount = itemCount
      )
      .run (err, nightmare) ->
        if err
          callback err if callback
          return

        if macAccessoriesCount
          callback null, macAccessoriesCount
        else
          callback new Error 'DOM Structure may be changed!' if callback
