chai = require "chai"
sinon = require "sinon"
chai.use require "sinon-chai"

expect = chai.expect

describe "wikipedia", ->
    beforeEach ->
        @robot =
            respond: sinon.spy()
            brain:
                get: (key) -> key
                set: (key) -> key

        require("../src/wikipedia")(@robot)

    it "registers a respond listener", ->
        expect(@robot.respond).to.have.been.calledWith(/wiki search (.+)/i)
        expect(@robot.respond).to.have.been.calledWith(/wiki summary (.+)/i)
        expect(@robot.respond).to.have.been.calledWith(/wiki language (\w{2})/i)
