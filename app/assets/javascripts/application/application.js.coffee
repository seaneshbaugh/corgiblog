#$ ->
#  if history and history.pushState
#    $("#search").on "submit", (event) ->
#      event.preventDefault()
#      $.get @action, $(this).serialize(), null, "script"
#      history.pushState null, document.title, @action + "?" + $(this).serialize()
#
#    $("body").on "click", ".nav a, .sort_link, .post-title a", (event) ->
#      event.preventDefault()
#      $.getScript @href
#      history.pushState null, "", @href
#
#    $(window).bind "popstate", ->
#      $.getScript location.href

$ ->
  pictures = $("#masonry")
  pictures.imagesLoaded ->
    pictures.masonry
      itemSelector: ".picture"
      columnWidth: (containerWidth) ->
        containerWidth / 4
