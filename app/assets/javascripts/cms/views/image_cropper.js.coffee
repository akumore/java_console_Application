$ ->
  new AlfredMueller.Cms.Views.ImageCropper

class window.AlfredMueller.Cms.Views.ImageCropper

  constructor: ->
    origWidth = $('#cropbox').data('original-width')
    origHeight = $('#cropbox').data('original-height')
    minSizeWidth = @minSizeWidth()

    $('#cropbox').Jcrop
      aspectRatio: 2
      minSize: [minSizeWidth, minSizeWidth/2]
      setSelect: [0, 0, origWidth, origWidth/2]
      trueSize: [origWidth, origHeight]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#image_crop_x').val(coords.x)
    $('#image_crop_y').val(coords.y)
    $('#image_crop_w').val(coords.w)
    $('#image_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    origWidth = $('#cropbox').data('original-width')
    origHeight = $('#cropbox').data('original-height')

    $('#preview').css
      width: Math.round(225/coords.w * origWidth) + 'px'
      height: Math.round(112/coords.h * origHeight) + 'px'
      marginLeft: '-' + Math.round(225/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(112/coords.h * coords.y) + 'px'

  minSizeWidth: ->
    origWidth = $('#cropbox').data('original-width')
    if origWidth >= 1000
      1000
    else
      origWidth

