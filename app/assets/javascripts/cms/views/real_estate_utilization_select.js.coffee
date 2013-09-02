class window.AlfredMueller.Cms.Views.RealEstateUtilizationSelect

  constructor: (@elem) ->
    @elem.change ->
      current_utilization = $('#real_estate_utilization option:selected').val()
      $.ajax
        url: '/cms/real_estate_categories'
        data: { utilization:current_utilization }
