# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require jcrop
#= require jquery.autoresize
#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap
#= require underscore
#= require backbone
#= require ckeditor/init
#= require ./backbone_setup
#= require ./datatable
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers
#= require twitter/bootstrap
#= require_self


$(document).ready ->

  CKEDITOR.replaceAll('editor')

  $('.dropdown-toggle').dropdown()

  $("table.sortable tbody").sortable
    handle: ".drag-handle"
    update: (event, ui) ->
      $(this).find(".draggable-row").each (idx, elem) ->
        $(this).find("td.drag-handle input[type=hidden]").val(idx+1)
      $(this).closest("form.autosubmit").trigger("submit")

  $("textarea").autoResize()

  $(".help-popover").popover()
  $(".help-popover-top").popover
    placement: 'top'

  $("form div[data-dependent_on]").each ->
    elem = $(this)
    new AlfredMueller.Cms.Views.DependentDisplay(
      el: elem
      target: $(elem.data('dependent_on'))
      targetValue: elem.data('dependent_on_value')
    )

  $("form div[data-dependent-select_on]").each ->
    elem = $(this)
    new AlfredMueller.Cms.Views.DependentSelectDisplay(
      el: elem
      target: $(elem.data('dependent-select_on'))
      targetRadioGroup: $(elem.data('dependent-select_radio-group'))
    )

  # initialize real estate utilizations listener
  if $('#real_estate_utilization').length
    new AlfredMueller.Cms.Views.RealEstateUtilizationSelect $('#real_estate_utilization')

  # initialize real estate language listener 
  if $('#real_estate_office_id').length
    new AlfredMueller.Cms.Views.RealEstateOfficeSelect $('#real_estate_office_id')

  # initialize real estate categories listener
  if $('#real_estate_category_id').length
    new AlfredMueller.Cms.Views.RealEstateCategorySelect $('#real_estate_category_id')

$(window).load ->
  # initialize image cropper
  if $('#image-cropping').length
    new AlfredMueller.Cms.Views.ImageCropper $('#image-cropping')
