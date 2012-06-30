localMediaStream = null

# TODO get image sized correctly. Apply current filter to the image.
snapshot = ->
  video = $('video')
  canvas = $('canvas').attr('width', video.width()).attr('height', video.height()).get(0)


  ctx = canvas.getContext('2d')

  if localMediaStream
    video = $('video')

    ctx.drawImage(video.get(0), 0, 0)

    $('img').attr 'src', canvas.toDataURL('image/webp')

index = 0
filters = ['grayscale', 'sepia', 'blur']#, 'brightness', 'contrast', 'hue-rotate', 'hue-rotate2', 'hue-rotate3', 'saturate', 'invert', '']

changeFilter = (e) ->
  target = e.target

  effect = filters[index++ % filters.length]

  if effect
    $(target).attr('class', effect)

if Meteor.is_client
  Meteor.startup ->
    $('video').on 'click', (e) ->
      changeFilter(e)
      snapshot(e)

    video = $('video').get(0)
    navigator.webkitGetUserMedia {video: true}
    , (stream) ->
      video.src = webkitURL.createObjectURL(stream)
      localMediaStream = stream
    , (error) ->
      console.log error
