class window.AlfredMueller.Cms.Views.RealEstateCategorySelect

  constructor: (@elem) ->
    if !isRowHouse()
      $('.building-type-container').addClass('hidden')

    @elem.change ->
      if isRowHouse()
        $('.building-type-container').removeClass('hidden')
      else
        $('.building-type-container').addClass('hidden')

  isRowHouse = ->
    $('#real_estate_category_id option:selected').data('category_name') == 'row_house'

