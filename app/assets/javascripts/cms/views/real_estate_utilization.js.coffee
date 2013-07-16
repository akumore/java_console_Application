class window.AlfredMueller.Cms.Views.RealEstateUtilization

  constructor: (@elem) ->
    @elem.change ->
      data = $('#real_estate_utilization option:selected').val()
      $.ajax
        url: '/cms/real_estate_utilizations'
        data: { utilization:data }
