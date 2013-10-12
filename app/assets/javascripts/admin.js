//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require twitter/bootstrap
//= require vendor_assets
//= require ace
//= require shared
//= require_self

$(function() {
    $("body").tooltip({
        placement: "top",
        selector: "[rel*=tooltip]"
    });

    $("body").popover({
        selector: "[rel*=popover]",
        trigger: "hover"
    });

    $(".ace-editor").each(function() {
        var editorContainer, editorID, editorName, textarea, mode, theme, editor;

        editorContainer = $(this);

        editorID = editorContainer.attr("id");

        // This expects the editor ID to be in the form of "model_name_attribute-editor"
        editorName = "#" + editorID.split("-")[0];

        textarea = $(editorName);

        mode = editorContainer.data("mode").toLowerCase();

        if (mode === "erb") {
            mode = "rhtml";
        }

        if (textarea.length === 1 && ["coffee", "css", "html", "javascript", "json", "less", "rhtml", "ruby", "text"].indexOf(mode) !== -1) {
            $(textarea).hide();

            editor = ace.edit(editorID);

            $("#" + editorID).data("editor", editor);

            theme = editorContainer.data("theme");

            if (theme) {
                theme = theme.toLowerCase();
            } else {
                theme = "pastel_on_dark";
            }

            editor.setTheme("ace/theme/" + theme);

            editor.getSession().setMode("ace/mode/" + mode);

            editor.getSession().setValue($(textarea).val());

            editor.getSession().setTabSize(2);

            editor.getSession().setUseSoftTabs(true);

            editor.getSession().on("change", function() {
                $(textarea).val(editor.getSession().getValue());
            });
        }
    });

    $("body").on("submit", "#picture-selector-search-form", function(event) {
        event.preventDefault();
    });

    $("body").on("keyup", "#filter-by-title", function() {
        var filterTextBox, filterText;

        filterTextBox = $(this);

        filterText = filterTextBox.val();

        if (filterText.length > 0) {
            $(".picture-selector-picture").each(function() {
                var picture;

                picture = $(this);

                if (picture.data("picture-title") && picture.data("picture-title").toString().toLowerCase().match(filterText.toLowerCase())) {
                    picture.show();
                } else {
                    picture.hide();
                }
            });
        } else {
            $(".picture-selector-picture").show();
        }
    });

    $("body").on("click", ".picture-selector-picture", function(event) {
        var picture, target, img;

        event.preventDefault();

        picture = $(this);

        target = $(picture.closest(".modal").data("target"));

        if (target.length > 0 && target.data("editor")) {
            img = "<img src=\"" + picture.data("picture-url") + "\" alt=\"" + picture.data("picture-alt-text") + "\">";

            target.data("editor").insert(img);
        }

        $("#picture-selector-modal").modal("hide");
    });

    $("#pictures #new_picture").fileupload({
        dataType: "script",
        add: function(event, data) {
            var file, types;

            types = new RegExp("(\\.|\\/)(" + $(this).data("accept") + ")$", "i");

            file = data.files[0];

            if (types.test(file.type) || types.test(file.name)) {
                data.context = $($.trim(tmpl("template-upload", file)));

                $(this).append(data.context);

                return data.submit();
            } else {
                return alert("" + file.name + " is not a valid file");
            }
        },
        progress: function(event, data) {
            var progress;

            if (data.context) {
                progress = parseInt(data.loaded / data.total * 100, 10);

                data.context.find(".progress-bar").css("width", progress + "%").attr("aria-valuenow", progress.toString());
            }
        },
        done: function(event, data) {
            if (data.context) {
                data.context.find(".progress-bar").css("width", "100%").attr("aria-valuenow", "100");

                setTimeout(function(){
                    data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass("progress-bar-success").closest(".upload").fadeOut(4000);
                }, 500);
            }
        },
        fail: function(event, data) {
            if (data.context) {
                data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass("progress-bar-danger");
            }
        }
    });
});
