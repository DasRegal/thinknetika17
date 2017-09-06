# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
question_comments_subscript = ->
  if gon.question
    App.cable.subscriptions.create({
      channel: 'CommentsChannel',
      id: gon.question.id
    },{
      connected: ->
        @perform 'follow'
      ,

      received: (data) ->
        comment = JSON.parse(data)
        if comment.user_id != gon.current_user
          commentable = comment['commentable_type'].toLowerCase()
          id = comment['commentable_id']
          $(".#{commentable}_comments[data-id=#{id}] .comments_container").append(JST['templates/comment']({
            comment: comment
            }))
    })


$(document).on('turbolinks:load', question_comments_subscript)
