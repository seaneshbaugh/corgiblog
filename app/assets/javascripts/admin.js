//= require jquery
//= require jquery_ujs
//= require_self

var lastTextArea;

$(function(){
  // Close flash[:alert] messages when clicked
  $(".click-to-close").click(function() {
		$(this).fadeTo(400, 0, function () {
			$(this).slideUp(400);
		});
		return false;
	});

  // Reset focus to search forms if they have stuff in them
	if ($("#search").length) {
		if ($("#search").val().length > 0) {
			$("#search").focus();
		}
	}

  // AJAX history
	if (history && history.pushState) {
		$("#index-search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");

			history.pushState(null, document.title, this.action + "?" + $(this).serialize());

			return false;
		});

		$("th a, .pagination a").live("click", function() {
			$.getScript(this.href);

			history.pushState(null, "", this.href);

			return false;
		});

		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});
	}

  // Check all checkbox for index pages
	$(".check-all").click(function() {
		$(this).parent().parent().parent().parent().find("input[type='checkbox']").attr("checked", $(this).is(":checked"));
	});

  // Only allow multiple items to be edited/removed if at least one is selected
	$("input:checkbox").click(function() {
		var buttonsChecked = $("input:checkbox:checked");

		if (buttonsChecked.length) {
			$("#edit-selected-button").removeAttr("disabled");
			$("#delete-selected-button").removeAttr("disabled");
		} else {
			$("#edit-selected-button").attr("disabled", "disabled");
			$("#delete-selected-button").attr("disabled", "disabled");
		}
	});

  // Toggle debug view when showing items
	$("#toggle-debug").click(function() {
		$("#debug-info").slideToggle();

		$(".toggle-debug-text").toggle();
	});

  // Fill out user email confirmation so it doesn't have to be done manually every time
  $("#user_email_address_confirmation").val($("#user_email_address").val());

  // Empty user email confirmation if email changes
  $("#user_email_address").keyup(function() {
    $("#user_email_address_confirmation").val("");
    $("#user_email_address_confrimation").attr("placeholder", $("#user_email_address").val());
  });

  // Empty user password confirmation if password changess
  $("#user_password").keyup(function() {
    $("#user_password_confirmation").val("");
  });

  // Get picture selector
  $("#picture-selector-button").click(function(event) {
    event.preventDefault();

    if ($("#picture-selector-container").length === 0) {
      var jqxhr = $.get("/admin/pictures/selector", null, function(data, textStatus, jqXHR) {
        $(".content").append(data);
    	}, "html");
    }
  });

  lastTextArea = $("textarea").first();

  $("textarea").focus(function() {
    lastTextArea = this;
  });
});
