# Description:
#   Triggers allow you to make the robot respond with the given string.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   trigger phrase to response - Make the robot respond with "response" when it hears "phrase"
#   trigger delete phrase      - Delete the given trigger
#
# Author:
#   skalnik


module.exports = (robot) ->
  robot.respond /trigger (.*) to (.*)/, (msg) ->
    trigger = msg.match[1].trim()
    response = msg.match[2].trim()
    triggers = robot.brain.get('triggers')

    oldResponse = triggers[trigger]
    if oldResponse?
      msg.send "'#{trigger}' already triggers '#{oldResponse}'. Use trigger remove #{trigger} to delete it."
    else
      triggers[trigger] = response
      robot.brain.set('triggers', triggers)
      msg.send "I'll always say '#{response}' when I hear '#{trigger}'"

  robot.respond /trigger delete (.*)/, (msg) ->
    triggers = robot.brain.get('triggers')
    trigger = msg.match[1].trim()

    if triggers[trigger]?
      delete triggers[trigger]
      robot.brain.set('triggers', triggers)
      msg.send "I have forgot what to say when I hear '#{trigger}'"
    else
      msg.send "I have no idea what to say when I hear '#{trigger}'"

  robot.hear /(.*)/, (msg) ->
    triggers = robot.brain.get('triggers')
    fullMessage = msg.match[1].trim()
    for own trigger, reply of triggers
      if fullMessage.indexOf(trigger) != -1
        msg.send reply

  # Initialize the list of all triggers, if it doesn't exist yet.
  robot.brain.once 'loaded', (data) ->
    if not robot.brain.get('triggers')?
      robot.brain.set('triggers', {})
