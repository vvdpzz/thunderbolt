jQuery ->
  
  $('body').bind 'click', (e) ->
    $('a.menu').parent('li').removeClass('open')
  
  $('a.menu').click ->
    $(this).parent('li').toggleClass('open')
    false