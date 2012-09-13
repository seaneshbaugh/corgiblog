jQuery ->
  $("a[rel*=popover]").popover()
  $(".tooltip").tooltip({'placement': 'top'})
  $("a[rel*=tooltip]").tooltip({'placement': 'top'})
  $("button[rel*=tooltip]").tooltip({'placement': 'top'})
  $("input[rel*=tooltip]").tooltip({'placement': 'top'})
