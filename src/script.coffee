# Description:
#   Wikipedia Public API
#
# Dependencies:
#   "iso-639-1": "^1.2.4"
#
# Configuration:
#   HUBOT_WIKIPEDIA_LANG
#
# Commands:
#   hubot wiki search <query> - Get the first 5 articles
#   hubot wiki summary <article> - Get a one-line description
#   hubot wiki language <language> - Set a language for search
#
# Author:
#   lgaticaq

iso6391 = require("iso-639-1")

module.exports = (robot) ->
  options = {unfurl_links: false, as_user: true}

  robot.respond /wiki search (.+)/i, (res) ->
    search = res.match[1].trim()
    params =
      action: "opensearch"
      format: "json"
      limit: 5
      search: search
    wikiRequest(res, params).then (data) ->
      if data[1].length is 0
        res.reply "No articles were found using search query: *#{search}*"
        return
      message = data[1].map((x) -> "<#{createURL(x)}|#{x}>").join("\n")
      robot.adapter.client.web.chat.postMessage(
        res.message.room, message, options)
    .catch (err) ->
      robot.emit("error", err)
      res.reply("an error occurred. #{err.message}")

  robot.respond /wiki summary (.+)/i, (res) ->
    target = res.match[1].trim()
    params =
      action: "query"
      exintro: true
      explaintext: true
      format: "json"
      redirects: true
      prop: "extracts"
      titles: target
    wikiRequest(res, params).then (data) ->
      for id, article of data.query.pages
        if id is "-1"
          res.reply "The article you have entered *#{target}* does not exist"
          return
        if article.extract is ""
          summary = "No summary available"
        else
          url = "<#{createURL(article.title)}|Original article>"
          summary = ">#{article.extract.split('. ')[0..1].join('. ')}\n#{url}"
        robot.adapter.client.web.chat.postMessage(
          res.message.room, summary, options)
        return
    .catch (err) ->
      robot.emit("error", err)
      res.reply "an error occurred. #{err.message}"

  robot.respond /wiki language (\w{2})/i, (res) ->
    lang = res.match[1].trim()
    unless iso6391.validate(lang)
      return res.reply "#{lang} is not a valid ISO-639-1 language"
    robot.brain.set("wikipedia:lang", lang)
    res.send "Language set at *#{iso6391.getName(lang)}*"

  createURL = (title) ->
    base = "https://#{getLang()}.wikipedia.org"
    return "#{base}/wiki/#{encodeURIComponent(title)}"

  wikiRequest = (res, params={}) ->
    return new Promise (resolve, reject) ->
      res.http(getWikiUrl())
        .query(params)
        .get() (err, response, body) ->
          if err
            reject(err)
          else if (response.statusCode isnt 200)
            reject(new Error("Bad statusCode: #{response.statusCode}"))
          else
            resolve(JSON.parse(body))

  getLang = () ->
    LANG = robot.brain.get("wikipedia:lang") or
      process.env.HUBOT_WIKIPEDIA_LANG or "en"
    return if iso6391.validate(LANG) then LANG else "en"

  getWikiUrl = () ->
    return "https://#{getLang()}.wikipedia.org/w/api.php"
