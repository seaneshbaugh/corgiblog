//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor_assets
//= require shared
//= require_self

$.fn.fadingLinks = function(color, duration) {
    if (!duration) {
        duration = 500;
    }

    return this.each(function() {
        var element, original;

        element = $(this);

        original = element.css("color");

        element.mouseover(function() {
            return element.stop().animate({
                color: color
            }, duration);
        });

        return element.mouseout(function() {
            return element.stop().animate({
                color: original
            }, duration);
        });
    });
};

$(function() {
    $("a").each(function() {
        var link;

        link = $(this);

        if (link.data("hover-color")) {
            link.fadingLinks(link.data("hover-color"));
        } else {
            link.fadingLinks("#aa0048");
        }
    });

    $("#tiles").imagesLoaded(function() {
        var handler, options, nextPage, lastPageReached, loading;

        handler = null;

        options = {
            autoResize: true,
            container: $("#pictures"),
            offset: 5,
            outerOffset: 10,
            itemWidth: 210
        };

        function applyLayout() {
            $("#tiles").imagesLoaded(function() {
                if (handler.wookmarkInstance) {
                    handler.wookmarkInstance.clear();
                }

                handler = $("#tiles li");

                handler.wookmark(options);
            });
        }

        nextPage = 1;

        lastPageReached = false;

        loading = false;

        $(window).on("scroll", function() {
            var windowHeight;

            if (!lastPageReached && !loading) {
                if (window.innerHeight) {
                    windowHeight = window.innerHeight;
                } else {
                    windowHeight = $(window).height();
                }

                if ($(window).scrollTop() + windowHeight > $(document).height() - 150) {
                    nextPage += 1;

                    loading = true;

                    $.getJSON("/pictures.json", {page: nextPage}, function(data) {
                        if (data.length === 0) {
                            lastPageReached = true;
                        } else {
                            $.each(data, function(index, picture) {
                                var li, a, img;

                                li = $(document.createElement("li"));

                                a = $(document.createElement("a")).attr("href", picture.original_image_url);

                                img = $(document.createElement("img")).attr("src", picture.medium_image_url).attr("width", picture.scaled_width).attr("height", picture.scaled_height).attr("alt", picture.alt_text);

                                a.append(img);

                                li.append(a);

                                $("#tiles").append(li);
                            });

                            applyLayout();
                        }

                        loading = false;
                    });
                }
            }
        });

        handler = $("#tiles li");

        handler.wookmark(options);
    });
});
