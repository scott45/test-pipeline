 # Behaviours and hooks for the updating and getting decision reasons
$(document).ready ->

  # get decision reasons for a given status
  vof.getStatusReasons = (camperId, status, decisionReasonId, stage) ->
    $(decisionReasonId).html ''
    options = '<option value="" disabled> Select Reason </option>'
    reasons = []
    dropdown = ''
    $.ajax
      url: '/bootcampers/' + camperId + '/decision/' + status + '/reasons/' + stage
      type: 'GET'
      success: (stageBootcamperReasons) ->
        # append reasons to reasons dropdown
        $.each stageBootcamperReasons, (reason, select_state) ->
          # 1 indicates selected
          if select_state == "1"
            options += '<option value="' + reason + '" selected>' + reason + '</option>'
            dropdown += '<li><i class="material-icons">brightness_1</i> ' + reason + '</li>'
            reasons.push(reason)
          else
            options += '<option value="' + reason + '">' + reason + '</option>'
        defaultId = decisionReasonId.split('_').join '_default_'
        $(defaultId).text ''
        
        if reasons.length > 0
          decisionReasonsDropdown = '<ul class="decision-dropdown">' + dropdown + '</ul>'
          decisionReasons = reasons.join(', ')
          if decisionReasons.length > 20
            decisionReasons = decisionReasons.substring(0, 20) + ' ...'
          else
            $('.decision-reasons-dropdown-' + stage + camperId).addClass 'short-decision-reasons'
        else 
          decisionReasons =  'No Reason Given'
          decisionReasonsDropdown =  'No Reason Given'
          $('.decision-reasons-dropdown-' + stage + camperId).addClass 'short-decision-reasons'

          
        $('.decision-reasons-' + stage + camperId).text decisionReasons
        $('.decision-reasons-dropdown-' + stage + camperId).html decisionReasonsDropdown

        # generate a dropdown for an admin
        vof.generateDropdown $(decisionReasonId), options
        return
    return

  # populate the reason drop-down with reasons for status
  $('.reason-details').on 'click', ->
    camperId = @id.split('_').slice(1).join('_')
    decisionReasonOneId = '#reason1_' + camperId
    decisionTwoReasonId = '#reason2_' + camperId
    status1 = $('#decision1_status_' + camperId).val()
    status2 = $('#decision2_status_' + camperId).val()
    if status1 != 'In Progress'
      vof.getStatusReasons(camperId, status1, decisionReasonOneId, 1)
    if status2 != 'In Progress' and status1 == 'Advanced'
      vof.getStatusReasons(camperId, status2, decisionTwoReasonId, 2)
    else
      vof.disableDropDownFields(['#reason2_' + camperId])
      vof.displayHideSpanTexts(['#reason2_default_' + camperId], 'Not Applicable')
  
  # update decision reasons
  updateDecisionReason = (reasons, camper_id, url) ->
    $.ajax
      type: 'PUT'
      url: url
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-TOKEN', $('meta[name="csrf-token"]').attr('content')
        return
      data: reasons
      success: (response) ->
        Materialize.toast('Decision Reason(s) successfully updated', 5000, 'black')
    return

  # update bootcamper decision reasons
  $('select.camper-decision-reason').change ->
    camper_id = @id.split('_').slice(1).join('_')
    if 'reason1' ==  @id.split('_')[0]
      stage_reasons = 1: $(this).val()
      
    else
      stage_reasons = 2: $(this).val()
    reasons = decision_stage_reasons: stage_reasons

    url = '/bootcampers/' + camper_id + '/decision_reasons'
    updateDecisionReason(reasons, camper_id, url)

  return
