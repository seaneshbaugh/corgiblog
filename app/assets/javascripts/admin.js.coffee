#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-ui
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require twitter/bootstrap
#= require twitter/typeahead
#= require bootstrap-tokenfield
#= require ace/ace
#= require ace/mode-coffee
#= require ace/mode-css
#= require ace/mode-html
#= require ace/mode-javascript
#= require ace/mode-json
#= require ace/mode-less
#= require ace/mode-rhtml
#= require ace/mode-ruby
#= require ace/mode-text
#= require ace/theme-pastel_on_dark
#= require shared
#= require_self
#= require turbolinks

$ ->
  $("body").tooltip
    placement: "top"
    selector: "[rel*=tooltip]"

  $("body").popover
    selector: "[rel*=popover]"
    trigger: "hover"

  ace.config.set("basePath", "/assets/ace")

  $(".ace-editor").each ->
    editorContainer = $(this)

    editorID = editorContainer.attr("id")

    # This expects the editor ID to be in the form of "model_name_attribute-editor"
    editorName = "#" + editorID.split("-")[0]

    textarea = $(editorName)

    mode = editorContainer.data("mode").toLowerCase()

    if mode == "erb"
      mode = "rhtml"

    if textarea.length == 1 and [
        "coffee"
        "css"
        "html"
        "javascript"
        "json"
        "less"
        "rhtml"
        "ruby"
        "text"
      ].indexOf(mode) != -1

      textarea.hide()

      editor = ace.edit(editorID)

      editor.$blockScrolling = Infinity

      $("#" + editorID).data "editor", editor

      theme = editorContainer.data("theme")

      if theme
        theme = theme.toLowerCase()
      else
        theme = "pastel_on_dark"

      editor.setTheme "ace/theme/" + theme

      editor.getSession().setMode "ace/mode/" + mode

      editor.getSession().setValue textarea.val()

      editor.getSession().setTabSize 2

      editor.getSession().setUseSoftTabs true

      editor.getSession().on "change", ->
        $(textarea).val editor.getSession().getValue()

  engine = new Bloodhound
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/admin/tags.json?q=%QUERY'
      wildcard: '%QUERY'

  engine.initialize

  $(".tokenfield").tokenfield
    allowDuplicates: false
    createTokensOnBlue: true
    typeahead: [null, { source: engine.ttAdapter() }]

  $("body").on "click", ".picture-inserter-button", (event) ->
    event.preventDefault()

    pictureInserterButton = $(this)

    modal = $(pictureInserterButton.data("target"))

    modal.load pictureInserterButton.attr("href")

  $("body").on "submit", "#picture-selector-search-form", (event) ->
    event.preventDefault()

  $("body").on "keyup", "#filter-by-title", ->
    filterTextBox = $(this)

    filterText = filterTextBox.val()

    if filterText.length > 0
      $(".picture-selector-picture").each ->
        picture = $(this)

        if picture.data("picture-title") and picture.data("picture-title").toString().toLowerCase().match(filterText.toLowerCase())
          picture.show()
        else
          picture.hide()
    else
      $(".picture-selector-picture").show()

  $("body").on "click", ".picture-selector-picture", (event) ->
    event.preventDefault()

    picture = $(this)

    modal = picture.closest(".modal")

    target = $(modal.data("target"))

    if target.length > 0 and target.data("editor")
      img = "<img src=\"" + picture.data("picture-url") + "\" alt=\"" + picture.data("picture-alt-text") + "\">"

      target.data("editor").insert img

    modal.modal "hide"

  $("#new_picture-fileupload").fileupload
    dataType: "script"
    add: (event, data) ->
      types = new RegExp("(\\.|\\/)(" + $(this).data("accept") + ")$", "i")

      file = data.files[0]

      if types.test(file.type) or types.test(file.name)
        data.context = $($.trim(tmpl("template-upload", file)))

        $(this).append data.context

        data.submit()
      else
        alert "" + file.name + " is not a valid file"
    progress: (event, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)

        data.context.find(".progress-bar").css("width", progress + "%").attr "aria-valuenow", progress.toString()
    done: (event, data) ->
      if data.context
        data.context.find(".progress-bar").css("width", "100%").attr "aria-valuenow", "100"

        setTimeout (->
          data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass("progress-bar-success").closest(".upload").fadeOut 4000
        ), 500
      return
    fail: (event, data) ->
      if data.context
        data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass "progress-bar-danger"
