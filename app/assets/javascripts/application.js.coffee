#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require twitter/bootstrap
#= require vendor_assets
#= require shared
#= require_self
#= require turbolinks

$ ->
  $("a").each ->
    link = $(this)

    hoverColor = link.data("hover-color")

    if hoverColor
      link.fadingLinks hoverColor
    else
      link.fadingLinks "#aa0048"

  $("#tiles").imagesLoaded ->
    handler = null

    applyLayout = ->
      $("#tiles").imagesLoaded ->
        if handler.wookmarkInstance
          handler.wookmarkInstance.clear()

        handler = $("#tiles li")

        handler.wookmark options

    options =
      autoResize: true
      container: $("#pictures")
      offset: 5
      outerOffset: 10
      itemWidth: 210

    nextPage = 1

    lastPageReached = false

    loading = false

    $(window).on "scroll", ->
      if !lastPageReached and !loading
        if window.innerHeight
          windowHeight = window.innerHeight
        else
          windowHeight = $(window).height()

        if $(window).scrollTop() + windowHeight > $(document).height() - 150
          nextPage += 1

          loading = true

          $.getJSON "/pictures.json", { page: nextPage }, (data) ->
            if data.length == 0
              lastPageReached = true
            else
              $.each data, (index, picture) ->
                li = $(document.createElement("li"))

                a = $(document.createElement("a")).attr("href", picture.original_image_url)

                img = $(document.createElement("img")).attr("src", picture.medium_image_url).attr("width", picture.scaled_width).attr("height", picture.scaled_height).attr("alt", picture.alt_text)

                a.append img

                li.append a

                $("#tiles").append li

              applyLayout()

            loading = false

    handler = $("#tiles li")

    handler.wookmark options
