vote = ->
  $(document).on 'ajax:success', '.vote', (e) ->
    $(this).parent().find('p.total_votes').html(e.detail[0])
  $(document).on 'ajax:error', '.vote', (e) ->
    $('.noty_wrapper').html(e.detail[0])


$(document).ready(vote) # "вешаем" функцию ready на событие document.ready
$(document).on('turbolinks:load', vote)  # "вешаем" функцию ready на событие page:load
