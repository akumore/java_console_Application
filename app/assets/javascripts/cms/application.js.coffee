# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone_datalink
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers
#= require twitter/bootstrap
#= require_self


window.AlfredMueller =
  Cms: {
    Models: {}
    Collections: {}
    Routers: {}
    Views: {}
  }

$(document).ready ->
  $('.dropdown-toggle').dropdown()

  $("table.sortable tbody").sortable
    handle: ".drag-handle"
    update: (event, ui) ->
      $("table.sortable .draggable-row").each (idx, elem) ->
        console.log($(this).find("input[type=hidden]"))
        $(this).find("input[type=hidden]").val(idx+1)
