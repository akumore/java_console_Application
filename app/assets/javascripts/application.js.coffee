# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the the compiled file.
#
#= require jquery
#= require jquery_ujs
#= require monster
#= require jquery.remotipart
#= require jquery.flexslider
#= require jquery.fancybox
#= require jquery.placeholder
#= require jquery.lazyload
#= require scrollTo
#= require underscore
#= require backbone
#= require h5bp
#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers
#= require chosen-jquery

window.AlfredMueller =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  new AlfredMueller.Routers.Application()
