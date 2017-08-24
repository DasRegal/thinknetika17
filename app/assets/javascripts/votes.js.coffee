vote_up = ->
  $('.vote_up').bind 'ajax:success', (e) ->
    $(this).parent().find('p.total_votes').html(e.detail[0])
vote_down = ->
  $('.vote_down').bind 'ajax:success', (e) ->
    # console.log e.detail[0]
    $(this).parent().find('p.total_votes').html(e.detail[0])


$(document).ready(vote_up)
$(document).ready(vote_down) # "вешаем" функцию ready на событие document.ready
$(document).on('turbolinks:load', vote_up)
$(document).on('turbolinks:load', vote_down)  # "вешаем" функцию ready на событие page:load
