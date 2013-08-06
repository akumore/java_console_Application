$ ->
  new AlfredMueller.Cms.Views.ImageCropper

class window.AlfredMueller.Cms.Views.ImageCropper

  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 2
      setSelect: [0, 0, 600, 340]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#image_crop_x').val(coords.x)
    $('#image_crop_y').val(coords.y)
    $('#image_crop_w').val(coords.w)
    $('#image_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(50/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(50/coords.h * coords.y) + 'px'
