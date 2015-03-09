class window.AlfredMueller.Views.Tabs extends Backbone.View

  events:
    'click .tabs-navigation li' : 'handleClick'
    'change .select-filter select' : 'handleChange'

  initialize: ->
    @navigationItems = @el.find('.tabs-navigation li')
    @contentItems = @el.find('.tabs-content .content')
    @select = @el.find('.mobile-view select')
    @initiallyOpenTab()

  initiallyOpenTab: ->
    if window.location.hash.indexOf('tab-')
      h = window.location.hash.replace('tab-', '')
      linkItem = $('a[href=' + h + ']')
      @updateSelect(h)
      $(linkItem).click()

  makeActive: (link) ->
    @deactivateAll()
    link.parent().addClass('selected')
    @activateContent(link.attr('href'))

  deactivateAll: ->
    @navigationItems.removeClass('selected')
    @contentItems.removeClass('active')

  handleClick: (event) ->
    event.preventDefault()
    link = $(event.target)
    @makeActive(link)
    @updateSelect(link.attr('href'))
    @updateHash(link.attr('href'))

  handleChange: (event) ->
    target = $(event.target).find(':selected').val()
    link = $('a[href=' + target + ']')
    @makeActive(link)
    @updateHash(link.attr('href'))

  activateContent: (id) ->
    $(id).addClass('active')
    $(id).find('.flexslider').resize()

  updateHash: (newHash) ->
    window.location.hash = 'tab-' + newHash.replace('#', '')

  updateSelect: (value) ->
    @select.val(value)
