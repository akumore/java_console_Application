class window.AlfredMueller.Views.SearchFilterOptionsUpdater extends Backbone.View

  events:
    "change #search_filter_cantons" : "updateCities"

  initialize: ->
#    console.log 'SearchFilter initializing...'
    @cantonsSelect = $("#search_filter_cantons")
    @citiesSelect = $("#search_filter_cities")
    @initialCities = @citiesSelect.find("option")
    @map = @citiesSelect.data('cantons-cities-map')
    @updateCities()

  updateCities: =>
    #console.log 'updateCities called', @remainingOptions()
    @clearCitiesOptions()
    @addCitiesOptions(@remainingOptions())
    @notifyCities()


  remainingOptions: ->
    if _.isEmpty(@selectedCantons())
      @initialCities
    else
      @citiesToOptions(@availableCities())

  clearCitiesOptions: ->
    @citiesSelect.empty()

  addCitiesOptions: (options) ->
    for option in options
      $(option).appendTo(@citiesSelect)

  citiesToOptions: (cities) ->
    _.select @initialCities, (city) ->
      _.include cities, city.value

  availableCities: ->
    cities = []
    for canton in @selectedCantons()
      cities.push @map[canton]
    _.uniq _.flatten cities

  selectedCantons: ->
    _.map  @cantonsSelect.find("option:selected"), (option) ->
      option.value

  notifyCities: ->
    @citiesSelect.trigger("liszt:updated")
