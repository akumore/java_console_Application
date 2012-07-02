class window.AlfredMueller.Views.RealEstateFilter extends Backbone.View

  initialize: ->
    # find visible element, controlled by mq css
    @mobileFilterView = @el.find(".mobile-view:visible")

    # offer / utilization type selects, they should act like the tab-links and filter immediately
    if @mobileFilterView.length > 0
      @mobileFilterView.find("select").each ->
        $(this).bind "change", ->
          $(this).closest("form").trigger("submit")
