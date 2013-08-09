$ ->
  new AlfredMueller.Cms.Views.ImageCropper

class window.AlfredMueller.Cms.Views.ImageCropper

  constructor: ->
    @initJcrop 2

    $('#fix_ratio').attr('checked','checked')

    $("#fix_ratio").change (e) =>
      if @checked
        ratio = 2 
      else 
        ratio = 0
      @initJcrop(ratio)

  update: (coords) =>
    $('#image_crop_x, #floor_plan_crop_x').val(coords.x)
    $('#image_crop_y, #floor_plan_crop_y').val(coords.y)
    $('#image_crop_w, #floor_plan_crop_w').val(coords.w)
    $('#image_crop_h, #floor_plan_crop_h').val(coords.h)

  minSizeWidth: ->
    origWidth = $('#cropbox').data('original-width')
    if origWidth >= 1000
      1000
    else
      origWidth

  initJcrop: (ratio) ->
    origWidth = $('#cropbox').data('original-width')
    origHeight = $('#cropbox').data('original-height')
    minSizeWidth = @minSizeWidth()

    $('#cropbox').Jcrop
      aspectRatio: ratio
      minSize: [minSizeWidth, minSizeWidth/2]
      setSelect: [0, 0, origWidth, origWidth/2]
      trueSize: [origWidth, origHeight]
      onSelect: @update
      onChange: @update

