$.fn.fadingLinks = (color, duration) ->
  if !duration
    duration = 500

  @each ->
    element = $(this)

    original = element.css("color")

    element.mouseover ->
      element.stop().animate { color: color }, duration

    element.mouseout ->
      element.stop().animate { color: original }, duration
