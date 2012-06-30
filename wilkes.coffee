Photos = new Meteor.Collection 'photos'

localMediaStream = null

# TODO get image sized correctly. Apply current filter to the image.
snapshot = ->
  video = $('video')
  canvas = $('canvas').attr('width', video.width()).attr('height', video.height()).get(0)

  ctx = canvas.getContext('2d')

  if localMediaStream
    video = $('video')

    ctx.drawImage(video.get(0), 0, 0)

    Photos.insert
      src: canvas.toDataURL('image/webp')
      filter: video.attr('class')

index = 0
filters = ['grayscale', 'sepia', 'blur', 'brightness', 'contrast', 'hue-rotate', 'hue-rotate2', 'hue-rotate3', 'saturate', 'invert', '']

changeFilter = (e) ->
  target = e.target

  effect = filters[index++ % filters.length]

  if effect
    $(target).attr('class', effect)

if Meteor.is_client
  Template.video.video = ->
    if navigator.webkitGetUserMedia
      "<video autoplay></video><div class='take_photo'></div>"
    else
      """
        <p>Looks like the camera isn't enabled. We can fix this.</p>
        <ul>
          <li>Use Chrome.</li>
          <li>Navigate to "chrome://flags".
          <li>Switch on the flags: 'Enable Media Source API on video elements.' and 'Enable MediaStream.'</li>
          <li>Restart your browser.</li>
        </ul>
      """

  Template.gallery.photos = ->
    output = ""

    Photos.find().forEach (photo) ->
      output += "<img class='preview #{photo.filter}' src='#{photo.src}' />"

    output

  Meteor.startup ->
    $('.take_photo').on 'click', (e) ->
      snapshot(e)

    $('video').on 'click', (e) ->
      changeFilter(e)

    video = $('video').get(0)
    navigator.webkitGetUserMedia? {video: true}
    , (stream) ->
      video.src = webkitURL.createObjectURL(stream)
      localMediaStream = stream
    , (error) ->
      console.log error
