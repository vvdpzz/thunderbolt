jQuery ->
  
  $("ul.tabs li a").click ->
    link = $(this).closest("li")
    $.get this.href, ->
      $("ul.tabs li").removeClass("active")
      link.addClass("active")
    false
  
  false