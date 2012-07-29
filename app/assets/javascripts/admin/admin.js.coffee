#$ ->
#  if history and history.pushState
#    $("#search").on "submit", ->
#      $.get @action, $(this).serialize(), null, "script"
#      history.pushState null, document.title, @action + "?" + $(this).serialize()
#
#    $("body").on "click", ".sort_link, .pagination a, td a", ->
#      $.getScript @href
#      history.pushState null, "", @href
#
#    $(window).bind "popstate", ->
#      $.getScript location.href
