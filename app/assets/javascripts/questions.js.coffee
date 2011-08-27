jQuery ->
  
  $('body').bind 'click', (e) ->
    $('a.menu').parent('li').removeClass('open')
  
  $('a.menu').click ->
    $(this).parent('li').toggleClass('open')
    false
  
  $('a#follow-question').click ->
    link = $(this)
    $.get this.href, (data) ->
      if data.followed
        link.removeClass('green').addClass('white').html("取消关注")
      else
        link.removeClass('white').addClass('green').html("关注")
    false
  
  $('a#favorite-question').click ->
    link = $(this)
    $.get this.href, (data) ->
      if data.favorited
        link.removeClass('green').addClass('white').html("取消收藏")
      else
        link.removeClass('white').addClass('green').html "收藏"
    false
  
  false