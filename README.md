# hubot-wikipedia

[![Build Status](https://travis-ci.org/ClaudeBot/hubot-wikipedia.svg)](https://travis-ci.org/ClaudeBot/hubot-wikipedia)
[![devDependency Status](https://david-dm.org/ClaudeBot/hubot-wikipedia/dev-status.svg)](https://david-dm.org/ClaudeBot/hubot-wikipedia#info=devDependencies)

A Hubot script for interacting with [Wikipedia's API](https://en.wikipedia.org/w/api.php) (searching for articles and returning extracts).

See [`src/wikipedia.coffee`](src/wikipedia.coffee) for full documentation.


## Installation via NPM

1. Install the __hubot-wikipedia__ module as a Hubot dependency by running:

    ```
    npm install --save hubot-wikipedia
    ```

2. Enable the module by adding the __hubot-wikipedia__ entry to your `external-scripts.json` file:

    ```json
    [
        "hubot-wikipedia"
    ]
    ```

3. Run your bot and see below for available config / commands


## Commands

Command | Listener ID | Description
--- | --- | ---
hubot wiki search `query` | `wikipedia.search` | Returns the first 5 Wikipedia articles matching the search `query`
hubot wiki summary `article` | `wikipedia.summary` | Returns a one-line description about `article`
hubot wiki language `language` | `wikipedia.language` | Set `language` as language for search


## Sample Interaction

```
user1>> hubot wiki summary clean room design
hubot>> Clean room design: Clean room design (also known as the Chinese wall technique) is the method of copying a design by reverse engineering and then recreating it without infringing any of the copyrights and trade secrets associated with the original design. Clean room design is useful as a defense against copyright and trade secret infringement because it relies on independent invention.
hubot>> Original article: https://en.wikipedia.org/wiki/Clean%20room%20design
```
