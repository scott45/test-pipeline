# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $adminMenuBtn = $('.admin-menu-button')
  $icons = $adminMenuBtn.find('.icon-wrapper')
  urlPath = location.pathname

  $icons.click ->
    $adminMenuBtn.toggleClass 'open'
    return

  # Prepare data to populate edit form
  populateOutputForm = (data) ->
    populate_criteria_list data.framework_id, data.criteria_name
    $('#assessment-name-id').val(data['name'])
    $('#assessment-description').val(data['description'])
    $('#output-modal').find('.select-dropdown')[0].value = data['framework_name']
    $('#assessment_criterium_id').val(data['criterium_id'])
    $('#framework_criterium_framework_id').val(data['framework_id'])
    $('#framework_criterium_criterium_id').val(data['criterium_id'])
    $('#framework-criterium-id').val(data['framework_criterium_id'])
    $('#context').val(data['context'])
    $('input[type=text][id="N/R"]').val(data['metrics'][0]['description'])
    $('input[type=text][id="Below Expectations"]').val(data['metrics'][1]['description'])
    $('input[type=text][id="At Expectations"]').val(data['metrics'][2]['description'])
    $('input[type=text][id="Exceeds Expectations"]').val(data['metrics'][3]['description'])
    $('input[type=hidden][id="metric_N/R"]').val(data['metrics'][0]['id'])
    $('input[type=hidden][id="metric_Below Expectations"]').val(data['metrics'][1]['id'])
    $('input[type=hidden][id="metric_At Expectations"]').val(data['metrics'][2]['id'])
    $('input[type=hidden][id="metric_Exceeds Expectations"]').val(data['metrics'][3]['id'])
    return

  # populate criteria dropdown on framework change
  $('#framework_criterium_framework_id').on 'change', ->
    framework_id = $('#framework_criterium_framework_id').val()
    populate_criteria_list(framework_id)
    return

  # populate criteria dropdown
  populate_criteria_list = (framework_id, criterion_name) ->
    #remove all previous majors
    $('#framework_criterium_criterium_id').empty()
    $('#framework_criterium_criterium_id').append($('<option></option>').attr('value', '').text('Select Criterion'))
    $.ajax
      type: 'GET'
      url: '/framework/' + framework_id + '/criteria'
      success: (data)->
        i = 0
        while i < data.length
          $('#framework_criterium_criterium_id').
          append($('<option></option>').attr('value', data[i].id).text(data[i].name))
          i++
          $('#framework_criterium_criterium_id').material_select()
        if criterion_name then $('#output-modal').find('.select-dropdown')[2].value = criterion_name
    return

  # set framework_criterium_id on criterium change
  $('#framework_criterium_criterium_id').on 'change', ->
    framework_id = $('#framework_criterium_framework_id').val()
    criterium_id = $('#framework_criterium_criterium_id').val()

    $.ajax
      type: 'GET'
      url: '/framework-criteria/' + framework_id + '/' + criterium_id
      data:
        framework_id: framework_id
        criterium_id: criterium_id
      success: (response)->
        $('#framework-criterium-id').val(response)
    return

  # Populate the edit form on click of edit button
  $('.assessments-body').on 'click', '.edit-output-modal', (e) ->
    assessment_id = $(this).closest('.assessment-section').attr('id')
    $.ajax
      type: 'GET'
      url: '/assessments/' + assessment_id
      contentType: 'application/json;charset=utf-8'
      dataType: 'json'
      success: (data)->
        $('#output-modal').modal 'open'
        $('h5.modal-header-text').text 'Edit Output'
        $('#output-modal').find('label').addClass 'active'
        populateOutputForm(data)
        $('.new_assessment').attr("action", "/assessments/" + assessment_id)
        $('.new_assessment').attr("method", "put")
    return

  # This initialize and activates the Add Criterion modal
  handleCriterionModal = (method = 'post', title = "Add Criterion", id, criterium) ->
    $('.modal').modal()
    $('#criterion-modal').find('label').addClass('active')
    $('#criterion-modal').find('#criterion').val if criterium then criterium.name else ''
    $('#criterion-modal').find('#criterion-id').val if criterium then criterium.id else ''
    $('#criterion-modal').find('#description').val if criterium then criterium.description else ''
    $('#criterion-modal select#frameworks').val([])
    $('#criterion-modal select#frameworks option:first').attr('disabled', 'disabled')
    if criterium
      selected_frameworks = criterium.frameworks.map (framework) -> framework.id
      $('#criterion-modal select#frameworks').val(selected_frameworks)
    $('#criterion-modal select#frameworks').material_select();
    $('#new_criterium').attr("action", if id then "/criteria/" + id else "/criteria/")
    $('#new_criterium').attr("method", method)
    $('#criterion-modal').find('#modal-header').find("h4").text(title)
    $('.new_criterium .btn-save')[0].addEventListener('click', validateCriterionFrameworks)
    $('#criterion-modal').modal 'open'
    return

  handleOutputModal = ->
    $('#content-swipe').tabs()
    $('#content-swipe').tabs('select_tab', 'outputs')
    $('.modal').modal()
    $('#output-modal').modal 'open'
    $('h5.modal-header-text').text 'Add Output'
    $('#new_assessment')[0].reset()
    $('#output-modal').find('label').addClass 'active'
    return

  openCriterionModal = ->
    if urlPath != '/content_management'
      localStorage.setItem 'criterion-modal', 'open'
      window.location = '/content_management'
      return

    $('#content-swipe').tabs('select_tab', 'criteria')
    handleCriterionModal()
    return
  
  # This clicks on the Add Criterion link
  $('#open-criterion-modal').click ->
    openCriterionModal()

  $('#sidenav-criterion-modal').click ->
    openCriterionModal()

  if urlPath == '/content_management' and localStorage.getItem('criterion-modal') == 'open'
    handleCriterionModal()
    localStorage.setItem 'criterion-modal', ''

  validateCriterionFrameworks = (event) ->
    if $('.new_criterium select#frameworks')[0].selectedIndex == -1
      Materialize.toast('Please select at least one framework', 5000, 'red')
      event.preventDefault()

  openOutputModal = ->
    # Redirects to content management page if current path isn't content management page
    if urlPath != '/content_management'
      localStorage.setItem 'output-modal', 'open'
      window.location = '/content_management'
      return

    handleOutputModal()
    return
  
  # This clicks on the Add Output link
  $('#open-output-modal').click ->
    openOutputModal()

  $('#sidenav-output-modal').click ->
    openOutputModal()

  # Pops-up Add Output modal if current path is content management page
  if urlPath == '/content_management' and localStorage.getItem('output-modal') == 'open'
    handleOutputModal()
    localStorage.setItem 'output-modal', ''
    return

    $('.modal').modal()
    $('#output-modal').modal('open')
    localStorage.setItem 'output-modal', ''

  # Click on the edit criterion icon and update edited data
  $('.criteria-table-body').on('click', '.edit-criterium', ->
    id = this.id.split("_")[1]
    $.ajax
      type: 'GET'
      url: '/criteria/' + id
      contentType: 'application/json;charset=utf-8'
      success: (criterium) ->
        handleCriterionModal('put', 'Edit Criterion', id, criterium)
  )

return
