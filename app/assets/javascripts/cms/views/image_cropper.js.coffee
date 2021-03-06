class window.AlfredMueller.Cms.Views.ImageCropper

  constructor: (@elem) ->
    src = @elem.find('img').attr('src')
    tmpImg = new Image()
    tmpImg.onload = =>
      @initJcrop(2)

      # check if aspect ratio checkbox is available

      if $('#fix_ratio').length
        $('#fix_ratio').attr('checked','checked')

        $('#fix_ratio').change (e) =>
          if $('#fix_ratio').attr('checked') == 'checked'
            ratio = 2
          else
            ratio = 0
          @initJcrop(ratio)

    tmpImg.src = src


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
