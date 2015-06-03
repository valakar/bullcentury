#ready = ->
#  alert('yas')
#  $("#user_birthday").datepicker
#    changeMonth: true,
#    changeYear: true,
#    yearRange: '1900:c'
#$(document).ready(ready)
#$(document).on('page:load', ready)
#

#initPage = ->
#  alert('yas')
#  $("#user_birthday").datepicker
#    changeMonth: true,
#    changeYear: true,
#    yearRange: '1900:c'
#  return
#
#$ ->
#  initPage()
#  return
#$(window).bind 'page:change', ->
#  initPage()
#  return

$ ->
  $(document).on 'change', '#countries_select', (evt) ->
    $.ajax 'update_cities',
      type: 'GET'
      dataType: 'script'
      data: {
        country_id: $("#countries_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

$ ->
  $('.tr-link').click( ->
  #    window.location = $(this).find('a').attr('href')
    project = $(this)
    goal = project.data('goal')
    categories = project.data('categories')
    country = project.data('country')
    pledged = project.data('pledged')
    currency = project.data('currency')
    project_id = project.data('id')
    bc_fees = pledged * 0.04
    total = pledged - bc_fees

    $('#section2 #goal').text(currency + goal)
    $('#section2 #categories').text(categories)
    $('#section2 #country').text(country)
    $('#section2 #pledged').text(currency + pledged)
    $('#section2 #bc_fees').text(currency + bc_fees)
    $('#section2 #total').text(currency + total)

    $('#submit-receive-money-form #project_to_submit').val(project_id)


    $('#section2').show()
    return
  ).hover ->
    $(this).toggleClass 'hover'
    return

$ ->
  $('#submit-project').click (e) ->
    e.preventDefault()
    window.location = $(this).attr('href')
#    alert('yas')
    return


#$ ->
#  $('.link-delete').bind 'ajax:beforeSend', ->
#    $('#section2').show()
#    return
#  $('.link-delete').bind 'ajax:complete', ->
#    $('#section2').hide()
#    return