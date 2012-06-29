if Meteor.is_client
  Meteor.startup ->
    video = $('video').get(0)
    navigator.getUserMedia 'video'
    , (stream) ->
      video.src = stream
    , (error) ->
      console.log error

if Meteor.is_server
  Meteor.startup ->
    ;