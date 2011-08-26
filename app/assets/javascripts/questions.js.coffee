jQuery ->
  
  $('body').bind 'click', (e) ->
    $('a.menu').parent('li').removeClass('open')
  
  $('a.menu').click ->
    $(this).parent('li').toggleClass('open')
    false
  
  $('a#follow-question').click ->
    $.get this.href, (data) ->
      if data.followed
        $('a#follow-question').removeClass('green').addClass('white').html("取消关注")
      else
        $('a#follow-question').removeClass('white').addClass('green').html("关注")
    false
  
  $('a#favorite-question').click ->
    $.get this.href, (data) ->
      if data.favorited
        $('a#favorite-question').removeClass('green').addClass('white').html("取消收藏")
      else
        $('a#favorite-question').removeClass('white').addClass('green').html "收藏"
    false
  
  false