Helper = require("hubot-test-helper")
expect = require("chai").expect
nock = require("nock")

helper = new Helper("./../src/index.coffee")

describe "hubot-wikipedia-lang", ->
  beforeEach ->
    nock.disableNetConnect()
    @room = helper.createRoom()
    @room.robot.adapter.client =
      web:
        chat:
          postMessage: (channel, text, options) =>
            @postMessage =
              channel: channel
              text: text
              options: options

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context "search", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "opensearch"
          format: "json"
          limit: 5
          search: "hubot"
        .reply 200, JSON.stringify(
          ["hubot", ["hubot 1", "hubot 2", "hubot 3", "hubot 4", "hubot 5"]])
      @room.user.say("user", "hubot wiki search hubot")
      setTimeout(done, 100)

    it "responds with results", ->
      message = "<https://en.wikipedia.org/wiki/hubot%201|hubot 1>\n" +
        "<https://en.wikipedia.org/wiki/hubot%202|hubot 2>\n" +
        "<https://en.wikipedia.org/wiki/hubot%203|hubot 3>\n" +
        "<https://en.wikipedia.org/wiki/hubot%204|hubot 4>\n" +
        "<https://en.wikipedia.org/wiki/hubot%205|hubot 5>"
      expect(@postMessage.text).to.eql message

  context "search without results", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "opensearch"
          format: "json"
          limit: 5
          search: "hubot"
        .reply 200, JSON.stringify(["hubot", []])
      @room.user.say("user", "hubot wiki search hubot")
      setTimeout(done, 100)

    it "responds with not found", ->
      expect(@room.messages).to.eql([
        ["user", "hubot wiki search hubot"],
        ["hubot", "@user No articles were found using search query: *hubot*"]
      ])

  context "search with error", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "opensearch"
          format: "json"
          limit: 5
          search: "hubot"
        .replyWithError("Server error")
      @room.user.say("user", "hubot wiki search hubot")
      setTimeout(done, 100)

    it "responds with not found", ->
      expect(@room.messages).to.eql([
        ["user", "hubot wiki search hubot"],
        ["hubot", "@user an error occurred. Server error"]
      ])

  context "summary", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "query"
          exintro: true
          explaintext: true
          format: "json"
          redirects: true
          prop: "extracts"
          titles: "hubot"
        .reply 200, JSON.stringify(
          {query: {pages: {1: {title: "hubot", extract: "A robot"}}}})
      @room.user.say("user", "hubot wiki summary hubot")
      setTimeout(done, 100)

    it "responds with summary", ->
      message = ">A robot\n" +
        "<https://en.wikipedia.org/wiki/hubot|Original article>"
      expect(@postMessage.text).to.eql message

  context "summary", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "query"
          exintro: true
          explaintext: true
          format: "json"
          redirects: true
          prop: "extracts"
          titles: "hubot"
        .reply 200, JSON.stringify({query: {pages: {"-1": {}}}})
      @room.user.say("user", "hubot wiki summary hubot")
      setTimeout(done, 100)

    it "responds with summary", ->
      expect(@room.messages).to.eql([
        ["user", "hubot wiki summary hubot"],
        ["hubot", "@user The article you have entered *hubot* does not exist"]
      ])

  context "summary", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "query"
          exintro: true
          explaintext: true
          format: "json"
          redirects: true
          prop: "extracts"
          titles: "hubot"
        .reply 200, JSON.stringify({query: {pages: {1: {extract: ""}}}})
      @room.user.say("user", "hubot wiki summary hubot")
      setTimeout(done, 100)

    it "responds with summary", ->
      expect(@postMessage.text).to.eql "No summary available"

  context "summary", ->
    beforeEach (done) ->
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "query"
          exintro: true
          explaintext: true
          format: "json"
          redirects: true
          prop: "extracts"
          titles: "hubot"
        .replyWithError("Server error")
      @room.user.say("user", "hubot wiki summary hubot")
      setTimeout(done, 100)

    it "responds with summary", ->
      expect(@room.messages).to.eql([
        ["user", "hubot wiki summary hubot"],
        ["hubot", "@user an error occurred. Server error"]
      ])

  context "summary", ->
    beforeEach (done) ->
      process.env.HUBOT_WIKIPEDIA_LANG = "xx"
      nock("https://en.wikipedia.org")
        .get("/w/api.php")
        .query
          action: "query"
          exintro: true
          explaintext: true
          format: "json"
          redirects: true
          prop: "extracts"
          titles: "hubot"
        .reply 301
      @room.user.say("user", "hubot wiki summary hubot")
      setTimeout(done, 100)

    it "responds with summary", ->
      expect(@room.messages).to.eql([
        ["user", "hubot wiki summary hubot"],
        ["hubot", "@user an error occurred. Bad statusCode: 301"]
      ])

  context "language", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot wiki language es")
      setTimeout(done, 100)

    it "responds with notification", ->
      message = ">A robot\n" +
        "<https://en.wikipedia.org/wiki/hubot|Original article>"
      expect(@room.messages).to.eql([
        ["user", "hubot wiki language es"],
        ["hubot", "Language set at *Spanish*"]
      ])

  context "language", ->
    beforeEach (done) ->
      @room.user.say("user", "hubot wiki language xx")
      setTimeout(done, 100)

    it "responds with notification", ->
      message = ">A robot\n" +
        "<https://en.wikipedia.org/wiki/hubot|Original article>"
      expect(@room.messages).to.eql([
        ["user", "hubot wiki language xx"],
        ["hubot", "@user xx is not a valid ISO-639-1 language"]
      ])
