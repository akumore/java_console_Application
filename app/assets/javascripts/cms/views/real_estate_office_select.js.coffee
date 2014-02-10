class window.AlfredMueller.Cms.Views.RealEstateOfficeSelect

  constructor: (@elem) ->
    @elem.change @change

  change: =>
    throw "officeLanguageMap undefinde" unless window.officeLanguageMap
    language = window.officeLanguageMap[@elem.val()]
    return unless language

    $('#real_estate_language').val(language)
