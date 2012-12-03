//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor_assets
//= require shared
//= require_self

$.fn.fadingLinks = function(color, duration) {
    if (duration == null) {
        duration = 500;
    }

    return this.each(function() {
        var original = $(this).css("color");

        $(this).mouseover(function() {
            return $(this).stop().animate({
                color: color
            }, duration);
        });

        return $(this).mouseout(function() {
            return $(this).stop().animate({
                color: original
            }, duration);
        });
    });
};

$(function() {
//    if (history && history.pushState) {
//        $("#search").on("submit", function(event) {
//            event.preventDefault();
//            $.get(this.action, $(this).serialize(), null, "script");
//            return history.pushState(null, document.title, this.action + "?" + $(this).serialize());
//        });
//        $("body").on("click", ".nav a, .sort_link, .post-title a", function(event) {
//            event.preventDefault();
//            $.getScript(this.href);
//            return history.pushState(null, "", this.href);
//        });
//        $(window).bind("popstate", function() {
//            return $.getScript(location.href);
//        });
//    }

    $("a").each(function() {
        if ($(this).data("hover-color") !== undefined) {
            $(this).fadingLinks($(this).data("hover-color"));
        } else {
            $(this).fadingLinks("#005580");
        }
    });

    var pictures = $("#masonry");

    pictures.imagesLoaded(function() {
        return pictures.masonry({
            itemSelector: ".picture",
            columnWidth: function(containerWidth) {
                return containerWidth / 4;
            }
        });
    });
});
