# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Populate dropdowns with ajax
$(document).ready ->
  $ ->
    selectedOptions = undefined
    outputQuality = undefined
    feedback = undefined
    valuesAlignment = undefined
    currentPhase = undefined
    scoreAssessment = 'Growth Mindset'
    frameworkHtml = $('#framework')

    checkIcon = ->
      '/assets/check-icon-11343b214e223d9266ff6ddff2c22958fe30b533cf8348f6174b88fc4e812885.png'

    getPhases = ->
      $.ajax
        type: 'GET'
        url: 'phases'
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (phases) ->
          getCompletedAssessments phases
          return
      return

    if $('#select_phase').length
      getPhases()

    dataReturned = ''
    completedAssessments = ''


    getFramework = (phaseId) ->
      $.ajax
        type: 'GET'
        url: 'phases/' + phaseId + '/assessments'
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (data) ->
          dataReturned = data
          frameworkOptions = ''
          $.each data, (framework, assessments) ->
            selected = ''
            if selectedOptions
              if framework == selectedOptions['framework']
                selected += 'selected'
            if completedAssessments[phaseId][framework]['completed']
              frameworkOptions += '<option ' + selected + ' value="' + framework + '" data-icon="' + checkIcon() + '" class="circle">' + framework + '</option>'
            else
              frameworkOptions += '<option ' + selected + ' value="' + framework + '">' + framework + '</option>'
            return

          # Generate dropdown for all framework options
          $('#select_framework').html ''
          vof.generateDropdown $('#select_framework'), frameworkOptions
          currentFramework = $('#select_framework :selected').val()
          getCriteria phaseId, currentFramework
          return
      return

    getCriteria = (phase, framework) ->
      # Build dropdown for criteria
      criteriaOptions = ''
      $.each dataReturned[framework], (criteria, assessments) ->
        selected = ''
        if selectedOptions
          if criteria == selectedOptions['criteria']
            selected += 'selected'
        if Object.keys(completedAssessments[phase][framework][criteria]).length == dataReturned[framework][criteria].length
          criteriaOptions += '<option ' + selected + ' value="' + criteria + '" data-icon="' + checkIcon() + '" class="circle">' + criteria + '</option>'
        else
          criteriaOptions += '<option ' + selected + ' value="' + criteria + '">' + criteria + '</option>'
        return

      # Generate dropdown for criteria options
      $('#select_criteria').html ''
      vof.generateDropdown $('#select_criteria'), criteriaOptions
      $('#framework_name').text $('#select_framework :selected').text() + ' - ' + $('#select_criteria :selected').text()
      currentCriteria = $('#select_criteria :selected').val()
      getAssessments phase, framework, currentCriteria
      return

    getAssessments = (phaseId, framework, criteria) ->
      $('#framework_body').html ''
      assessmentCard = ''
      $.each dataReturned[framework][criteria], (index, assessment) ->
        score = completedAssessments[phaseId][framework][criteria][assessment.id] || []
        assessmentCard += buildAssessmentCard(frameworkHtml.clone(), phaseId, assessment, index, score)

      $("#framework_body").append assessmentCard
      changeColor()
      return

    getCompletedAssessments = (phases) ->
      $.ajax
        type: 'GET'
        url: 'completed_assessments'
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (assessments) ->
          completedAssessments = assessments
          options = ''
          $.each phases, (index, phase) ->
            selectedPhase = ''
            if selectedOptions
              if Number(phase.id) == Number(selectedOptions['phase'])
                selectedPhase += 'selected'
            if completedAssessments[phase.id]['completed']
              options += '<option ' + selectedPhase + ' value="' + phase['id'] + '" data-icon="' + checkIcon() + '" class="circle">' + phase['name'] + '</option>'
            else
              options += '<option ' + selectedPhase + ' value="' + phase['id'] + '">' + phase['name'] + '</option>'
            return

          # get total progress percentage
          totalAssessed = completedAssessments['week_one']['assessed'] + completedAssessments['week_two']['assessed']
          totalAssessments = completedAssessments['week_one']['total'] + completedAssessments['week_two']['total']
          totalPercentage = (totalAssessed * 100 / totalAssessments).toFixed(1)

          # append total progress percentage
          $('#total-assessed').html totalAssessed
          $('#assessment-percentage').html totalPercentage
          $('#total-assessments').html totalAssessments

          # generate drop downs
          $('#select_phase').html ''
          vof.generateDropdown $('#select_phase'), options
          selectedPhase = $('#select_phase :selected').val()
          getFramework selectedPhase
          return
      return

    # build html for assessment card
    buildAssessmentCard = (element, phaseId, assessment, index, score) ->
      element.find('.assessment_name').html(assessment.name)
      element.find('[name="score[phase_id]"]').val(phaseId)
      element.find('[name="score[assessment_id]"]').val(assessment.id)
      normalized = assessment.name.replace(" ", "_").toLowerCase()

      if score[1]
        element.find('.input-field').find('#comments-label').addClass('active')
        element.find('.input-field').find('[name="score[comments]"]').html(score[1])

      if (index - 1) % 3 == 0
        element.find('.col.s4.framework').addClass 'assessment-margin'

      element.find('.input-wrapper').each (index) ->
        scoreInput = $(this).find('input[name="score[score]"]')
        scoreLabel = $(this).find('label')
        if Number(scoreInput.val()) == score[0]
          scoreLabel.addClass('checked')
        scoreInput.attr('name', "score[#{normalized}]")
        scoreLabel.attr('for', "score_#{normalized}_#{index}")

        if Number($(this).find('input[name="score[score]"]').val()) == score[0]
          $(this).find('label').addClass('checked')
        $(this).find('input[name="score[score]"]').attr('name', "score[#{normalized}]")
        $(this).find('#label').attr('for', "score_#{normalized}_#{index}")
      element.html()

    changeColor = ->
      $('.grade-button.enabled').click (e) ->
        parent = $(this).parent().parent()
        $(parent).find('label').removeClass 'checked'
        $(this).addClass 'checked'
      return

    $('#select_phase').change ->
      $('#select_framework').html ''
      currentPhase = $('#select_phase :selected').val()
      $('#score_phase_id').val currentPhase
      $('#comment-box').val ''
      $('#comments-label').removeClass 'active'
      selectedOptions = undefined
      getFramework currentPhase
      return

    $('#select_framework').change ->
      currentFramework = $('#select_framework :selected').val()
      currentPhase = $('#select_phase :selected').val()
      getCriteria currentPhase, currentFramework
      return

    $('#select_criteria').change ->
      currentPhase = $('#select_phase :selected').val()
      currentFramework = $('#select_framework :selected').val()
      currentCriteria = $('#select_criteria :selected').val()
      getAssessments currentPhase, currentFramework, currentCriteria
      $('#framework_name').text $('#select_framework :selected').text() + ' - ' + $('#select_criteria :selected').text()
      return

    # generate data for scoring an assessment
    scoreData = ->
      data = []
      $('.framework').each (index, assessment) ->
        $(assessment).find('.grade-button').parent().each (index, value) ->
          if $(value).find('label').hasClass('checked')
            scoreParams = {
              'phase_id': $('#select_phase :selected').val()
              'score': $(value).find('input').val(),
              'assessment_id': $(assessment).find('.comment-area').find('[name="score[assessment_id]"]').val(),
              'comments': $(assessment).find('.input-field').find('[name="score[comments]"]').val()
            }
            data.push(scoreParams)
      return data

    # ajax call for scoring all the assessments
    submitScore = ->
      $.ajax
        type: 'POST'
        url: 'scores/new'
        contentType: 'application/json;charset=utf-8'
        data: JSON.stringify({
          'scores': scoreData()
          })
      return

    # ajax call to get metrics from database
    getMetrics = (id) ->
      $.ajax
        type: 'GET'
        url: '/assessment/' + id
        contentType: 'application/json;charset=utf-8'
        dataType: 'json'
        success: (metrics) ->
          getMetricsGuide metrics
          return
      return

    # function to submit all the assessments in the form
    $('#submit-scores').click ->
      selectedOptions =
        'phase': $('#select_phase :selected').val()
        'framework': $('#select_framework :selected').val()
        'criteria': $('#select_criteria :selected').val()
      submitScore()
      setTimeout getPhases, 500
      return

    # split metric's description
    vof.getMetricDescription = (value) ->
      metricDescription = undefined
      metricDescription = value.description.split(' * ')[0]
      descriptionPart = value.description.split(' * ')[1]
      if descriptionPart != undefined
        metricDescription = metricDescription + '<br>' + descriptionPart
      return metricDescription

    # get all assessments score guide
    getMetricsGuide = (metrics) ->
      $('#assessmentContext').html metrics['context']
      $('#assessmentDescription').html metrics['description']
      $.each metrics['metrics'], (index, value) ->
        metricDescription = vof.getMetricDescription value
        $('#scoringContext').append '<tr><td>' + index + '</td><td class="tbody-content">' + metricDescription + '</td></tr>'
        return
      return

    $('.tooltipped').tooltip({delay: 50});
    # the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
    $('.modal').modal({
      ready: (modal, trigger) ->
        $('#scoringContext').find("tr").remove();
        $(this).find('#assessmentContext').text '';
        $(this).find('#assessmentDescription').text '';
        $(this).find('.score-guide-header').text '';
        if typeof trigger != 'undefined'
          scoreAssessment = trigger.parent().find('#assessment_name').text().trim()
        currentFramework = $('#select_framework :selected').text()
        currentCriteria = $('#select_criteria :selected').text()
        $('.score-guide-header').text scoreAssessment;
        $.each dataReturned[currentFramework][currentCriteria], (index, assessment) ->
          if scoreAssessment == assessment.name
            getMetrics assessment.id
          return
    })
    $('.modal-action').click (e) ->
      e.preventDefault()
      return
    return
  return
