#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require_self

#$ ->
#  if $(".pagination").length
#    $(window).scroll ->
#      url = $(".pagination .next a").attr("href")
#      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
#        $(".pagination").text("Loading more posts...")
#        $.getScript(url)
#    $(window).scroll()
  $(".click-to-close").click ->
    $(this).fadeTo 400, 0, ->
      $(this).slideUp 400
  $.fn.fadingLinks = (color, duration = 500) ->
    @each ->
      original = $(this).css("color")
      $(this).mouseover ->
        $(this).stop().animate color: color, duration
      $(this).mouseout ->
        $(this).stop().animate color: original, duration
