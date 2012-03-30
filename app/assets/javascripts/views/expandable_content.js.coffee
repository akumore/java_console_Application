# Easy handling of content elements that are expandable/collapsable via a more/less links.
# The structure should be as follows:
#
# <div id='something' class='expandable'>
#   some content
#   <a href='' class='more'>more</a>
#   <div class='expandable-content hidden'>
#     some content
#     <a href='#something' class='less'>less</a>
#   </div>
# </div>
#
# NOTE: Ideally, the less href points to the id of the .expandable div, so that
# when collapsing the expandable container the browser jumps back up.

class AlfredMueller.Views.ExpandableContent extends Backbone.View

  events:
    "click .more" : "handleOpen"
    "click .less" : "handleClose"

  initialize: ->
    @content = @el.find(".expandable-content")
    @more    = @el.find(".more")

  handleOpen: (event) =>
    @content.removeClass("hidden")
    @more.addClass("hidden")
    # allow anchoring, but prevent the event to bubble
    # up and open the content again in IE
    #event.stopPropagation()
    return false

  handleClose: (event) =>
    @content.addClass("hidden")
    @more.removeClass("hidden")
    # allow anchoring, but prevent the event to bubble
    # up and open the content again in IE
    #event.stopPropagation()
    return false
