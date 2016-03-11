# Description:
#   Wikipedia Public API
#
# Dependencies:
#   "iso-639-1": "^1.0.0"
#
# Configuration:
#   HUBOT_WIKIPEDIA_LANG
#
# Commands:
#   hubot wiki search <query> - Returns the first 5 Wikipedia articles matching the search <query>
#   hubot wiki summary <article> - Returns a one-line description about <article>
#   hubot wiki language <language> - Set <language> as language for search
#
# Author:
#   lgaticaq

iso6391 = require "iso-639-1"

module.exports = (robot) ->
    LANG = robot.brain.get("wikipedia:lang") or process.env.HUBOT_WIKIPEDIA_LANG or "en"
    LANG = if iso6391.validate(LANG) then LANG else "en"
    WIKI_API_URL = "https://#{LANG}.wikipedia.org/w/api.php"
    WIKI_EN_URL = "https://#{LANG}.wikipedia.org/wiki"

    robot.respond /wiki search (.+)/i, id: "wikipedia.search", (res) ->
        search = res.match[1].trim()
        params =
            action: "opensearch"
            format: "json"
            limit: 5
            search: search

        wikiRequest res, params, (object) ->
            if object[1].length is 0
                res.reply "No articles were found using search query: \"#{search}\". Try a different query."
                return

            for article in object[1]
                res.send "#{article}: #{createURL(article)}"

    robot.respond /wiki summary (.+)/i, id: "wikipedia.summary", (res) ->
        target = res.match[1].trim()
        params =
            action: "query"
            exintro: true
            explaintext: true
            format: "json"
            redirects: true
            prop: "extracts"
            titles: target

        wikiRequest res, params, (object) ->
            for id, article of object.query.pages
                if id is "-1"
                    res.reply "The article you have entered (\"#{target}\") does not exist. Try a different article."
                    return

                if article.extract is ""
                    summary = "No summary available"
                else
                    summary = article.extract.split(". ")[0..1].join ". "

                res.send "#{article.title}: #{summary}."
                res.reply "Original article: #{createURL(article.title)}"
                return

    robot.respond /wiki language (\w{2})/i, id: "wikipedia.language", (res) ->
        lang = res.match[1].trim()
        return res.reply "#{lang} is not a valid ISO-639-1 language" unless iso6391.validate(lang)
        robot.brain.set("wikipedia:lang", lang)
        setLanguage(lang)
        res.send "Language set at \"#{iso6391.getName(lang)}\""
        return

    createURL = (title) ->
        "#{WIKI_EN_URL}/#{encodeURIComponent(title)}"

    wikiRequest = (res, params = {}, handler) ->
        res.http(WIKI_API_URL)
            .query(params)
            .get() (err, httpRes, body) ->
                if err
                    res.reply "An error occurred while attempting to process your request: #{err}"
                    return robot.logger.error err

                handler JSON.parse(body)

    setLanguage = (lang) ->
        WIKI_API_URL = "https://#{lang}.wikipedia.org/w/api.php"
        WIKI_EN_URL = "https://#{lang}.wikipedia.org/wiki"