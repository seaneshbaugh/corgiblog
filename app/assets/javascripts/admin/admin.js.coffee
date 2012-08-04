$ ->
  $(".chzn-select").chosen({no_results_text: "No results matched"})

#  if history and history.pushState
#    $(document).on "click", ".ajax-link", (event) ->
#      event.preventDefault()
#      ajaxTarget = ""
#      if $(this).data("ajax-target") isnt undefined and $(this).data("ajax-target") isnt ""
#        ajaxTarget = $(this).data("ajax-taget")
#      else
#        ajaxTarget = "#content"
#      href = @href
#      $(ajaxTarget).fadeOut 500, ->
#        $.getScript href, ->
#          $(ajaxTarget).fadeIn 500
#      history.pushState null, document.title, href
#
#    $(document).on "submit", "#search", (event) ->
#      event.preventDefault()
#      ajaxTarget = ""
#      if $(this).data("ajax-target") isnt `undefined`
#        ajaxTarget = $(this).data("ajax-target")
#      else
#        ajaxTarget = "#content"
#      action = @action
#      params = $(this).serialize()
#      $(ajaxTarget).fadeOut 400, ->
#        $.getScript action, params, null, ->
#          $(ajaxTarget).fadeIn 400
#      history.pushState null, document.title, action + "?" + params
#
#    $(window).bind "popstate", ->
#      $.getScript location.href
