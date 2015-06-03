# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $(document).on 'click', '#pledge-button', ->
    pledge = prompt('How much do you want to pledge?', 10)
    if pledge
      if confirm('Do you want to pledge ' + pledge + '?')
        alert('Thank you for your pledge of ' + pledge)
      else
        alert('=(')

$(document).ready(ready)
$(document).on('page:load', ready)