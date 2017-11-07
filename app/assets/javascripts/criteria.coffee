# Behaviours and hooks for the updating and getting decision reasons
contentManagement = ->
    $(document).ready ->
        criteria_details = []
        assessments_details = {}
        filter_data = []
        
        # populateFramework: gets frameworks, criteria and assessment details from backend
        # and populates available frameworks
        vof.populateFramework = (optionId) ->
            $(optionId).html ''
            options = '<option value="" disabled> All </option>'
            $.ajax
                url: 'output/details'
                type: 'GET'
                success: (data) ->
                    assessments_details = data
                    criteria_details = data
                    if data.frameworks && data.frameworks.length > 0
                        for key, framework of data.frameworks
                            options += "<option value='#{framework.name}'>#{framework.name}</option>"
                        vof.generateDropdown $(optionId), options         
                    else
                    # vof.generateDropdown $(optionId), options
                    vof.filterCriteriaByFramework(null)
            return

        # displayOutput: Displays the filtered output
        vof.displayOutput = (data) ->
            action = ''
            if assessments_details.is_admin
                action = 
                    "<td class='table-action'>
                        <span>
                            <i class='material-icons edit-output-modal'>edit</i>
                            <i class='material-icons icon-delete'>delete</i>
                        </span>
                    </td>"
            
            for key, output of data
                options = ''
                for index, metric of output.metrics
                    metricDescription = vof.getMetricDescription metric
                    options += "<div class='points'>#{metric.point}<span class='scoring-metrics'>#{metricDescription}</span></div>"

                assessment_row =
                "<tr id='#{output.assessment.id}' class='assessment-row assessment-section'>
                    <td class='assessment-output'><span>#{output.assessment.name}</span></td>
                    <td class='assessment-description'><span>#{output.assessment.description}</span></td>
                    <td class='assessment-context'><span>#{output.assessment.context}</span></td>
                    <td class='assessment-metric'>#{options}</td>
                    <td class='assessment-framework'><span>#{output.framework}</span></td>
                    <td class='assessment-criterion'><span>#{output.criteria}</span></td>
                    #{action}
                </tr>"

                $("#assessment-body").append assessment_row

        # populateOutputByFramework: filters the output by framework
        vof.populateOutputByFramework = (frameworks) ->
            filtered_ouputs = []
            if frameworks isnt null
                for key, framework of frameworks    
                    result = assessments_details.assessments.filter (assessment) -> framework is assessment.framework
                    Array::push.apply filtered_ouputs, result
                filter_data = filtered_ouputs.reverse()
                vof.displayOutput(filter_data)
            else
                filter_data = assessments_details.assessments.reverse()
                vof.displayOutput(filter_data)

        # populateOutputByCriteria: filters the output by criteria     
        vof.populateOutputByCriteria = (criterium) ->
            filtered_ouputs = []
            if criterium isnt null
                for key, criteria of criterium    
                    result = filter_data.filter (assessment) -> criteria is assessment.criteria
                    Array::push.apply filtered_ouputs, result
                if filtered_ouputs.length < 1
                    noResult = '<tr class="output-row" ><td colspan="6"><h4 id="result-feedback">No Results Found</h4></td></tr>'
                    $("#assessment-body").append noResult
                else
                    vof.displayOutput(filtered_ouputs)
            else
                vof.displayOutput(filter_data)

        # triggers  populateOutputByFramework to filter by framework
        $('select.cms_output_framework').change ->
            selected_framework = $(this).val()
            $("#cms_output_criteria").html ''
            $("#assessment-body").html ''
            options = '<option value="" disabled> All </option>'

            if $(this).val() isnt null
                vof.populateOutputByFramework(selected_framework)
                for key, framework of selected_framework
                    for key, criteria_framework of assessments_details.criterium_frameworks         
                        if framework is criteria_framework.framework
                            options += "<option value='#{criteria_framework.criteria }'>#{criteria_framework.criteria}</option>"
                vof.generateDropdown $("#cms_output_criteria"), options
            else
                vof.populateOutputByFramework($(this).val())
                vof.generateDropdown $("#cms_output_criteria"), options

        # triggers  populateOutputByCriteria to filter by criteria
        $('select.cms_output_criteria').change ->
            selected_criteria = $(this).val()
            $("#assessment-body").html ''
            vof.populateOutputByCriteria(selected_criteria)

        # get frameworks and populate select options
        vof.populateCriteriaTable = (filtered_criteria) ->
            for key, criterium of filtered_criteria
                options = ""
                for index, framework of criterium.frameworks
                    options +="<li>#{framework.name}</li>"

                if criteria_details.is_admin
                    action = " <td id='criteria-row'>
                            <span>
                            <i class='material-icons icon-edit edit-criterium' id='criterium_#{criterium.id}'>edit</i>
                            <i class='material-icons icon-delete'>delete</i>
                            </span> </td>"
                criterium_row = 
                "<tr id='criterion-row-#{criterium.id}' class='criteria-row-wrapper'>
                    <td class='criteria-output name'> <span>#{criterium.name}</span></td>
                    <td class='criteria-output'><span class='output'>
                        <ul class='browser-default'>#{options}</ul>
                    </span></td>
                    <td class='criteria-description description'>
                        <span>
                        "+ if criterium['description'] is null || criterium['description'] is '' then 'N/A' else criterium['description']+"
                    </span>
                    </td>
                    #{action}
                    </tr>"
                $("#criteria-body").append criterium_row

        vof.filterCriteriaByFramework = (frameworks) ->
            if frameworks isnt null
                filtered_criteria = []
                for key, framework of frameworks
                    for key, criterium of criteria_details.criteria
                        for key, criteria_framework of criterium.frameworks
                            if criteria_framework.name is framework
                                filtered_result = criterium
                                if criterium not in filtered_criteria
                                    filtered_criteria.push(filtered_result)
                vof.populateCriteriaTable(filtered_criteria)
            else
                filtered_criteria = criteria_details.criteria
                vof.populateCriteriaTable(filtered_criteria)

        $('select.cms_framework_class').change ->
            $("#criteria-body").html ''
            vof.filterCriteriaByFramework($(this).val())

        vof.populateFramework('#cms_framework_id')
        vof.populateFramework('#cms_output_framework')

if window.location.pathname == '/content_management' then contentManagement() else ''