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

    if ($("#pictures").length !== 0) {
        var $pictures = $('#pictures'),
            filters = {};

        $pictures.find('.picture').each(function(){
            var $this = $(this),
                number = $this.attr('data-size');
            if ( number == 2 ) {
                $this.addClass('width2');
            }
            if ( number == 3 ) {
                $this.addClass('width3');
            }
        });

        $pictures.imagesLoaded( function(){
            $pictures.isotope({
                itemSelector : '.picture',
                masonry : {
                    columnWidth : 114
                },
                masonryHorizontal : {
                    rowHeight: 120
                },
                cellsByRow : {
                    columnWidth : 240,
                    rowHeight : 240
                },
                cellsByColumn : {
                    columnWidth : 240,
                    rowHeight : 240
                },
                getSortData : {
                    category : function( $elem ) {
                        return $elem.attr('data-category');
                    },
                    number : function( $elem ) {
                        return $elem.attr('data-size');
                    }
                }
            });
        });

        $(".sort").on("click", function(event) {
            event.preventDefault();

            $("#pictures").isotope({sortBy: $(this).data("sort-by") });
        });

        $("#shuffle").on("click", function(event) {
            event.preventDefault();

            $("#pictures").isotope("shuffle");
        });
    }
});
