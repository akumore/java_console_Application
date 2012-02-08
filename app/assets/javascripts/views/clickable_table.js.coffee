class window.AlfredMueller.Views.ClickableTable extends Backbone.View

  events:
    "click tr" : "handleClick"

  handleClick: (e) =>
    window.location.href = $(e.currentTarget).find("a:first-child").attr("href")