if Meteor.is_client
  Meteor.startup ->
    video = $('video').get(0)
    navigator.getUserMedia 'video'
    , (stream) ->
      video.src = stream
    , (error) ->
      console.log error

  Template.hello.events =
    'click input': ->
      console?.log "You pressed the button"

if Meteor.is_server
  Meteor.startup ->
    ;