class window.AlfredMueller.Cms.Views.RealEstateCategorySelect

  constructor: (@elem) ->
    @elem.change ->
      if $('#real_estate_category_id option:selected').data('category_name') == 'row_house'
        $('.building-type-container').removeClass('hidden')
      else
        $('.building-type-container').addClass('hidden')
