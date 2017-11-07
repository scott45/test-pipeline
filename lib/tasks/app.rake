namespace :app do
  desc "Calculates and updates the Bootcampers' averages"
  task compute_averages: :environment do
    Bootcamper.all.each do |camper|
      framework_averages = Score.framework_averages(camper.id)
      averages = {
        overall_average: Score.overall_average(camper.id),
        week1_average: Score.week_one_average(camper.id),
        week2_average: Score.week_two_average(camper.id),
        project_average: Score.final_project_average(camper.id),
        value_average: framework_averages[0],
        output_average: framework_averages[1],
        feedback_average: framework_averages[2]
      }
      camper.update(averages)
    end
    puts "Bootcampers' averages has been updated successfully"
  end

  desc "Updates assessment names"
  task update_assessment_names: :environment do
    code_assessment_name = "Code Syntax Norms"
    code_assessment = Assessment.find_by_name("Code Syntax Norms (PEP8/Airbnb)")
    code_assessment.update_attribute("name", code_assessment_name)

    project_assessment_name = "Project Management"
    project_assessment = Assessment.find_by_name("Trello/ Project Management")
    project_assessment.update_attribute("name", project_assessment_name)
  end

  desc "Convert lfas name to email"
  task convert_lfa_name_to_email: :environment do
    def convert_name_to_email(name)
      unless name.blank? || name.include?("@andela.com")
        name.downcase.tr(" ", ".").gsub(/[^\w@\.]/, "") << "@andela.com"
      end
    end

    Bootcamper.all.each do |bootcamper|
      bootcamper.update_attributes(
        week_one_lfa: convert_name_to_email(bootcamper.week_one_lfa),
        week_two_lfa: convert_name_to_email(bootcamper.week_two_lfa)
      )
    end
  end

  desc "Add references to programs"
  task add_references_to_programs: :environment do
    program = Program.first

    Bootcamper.all.each do |bootcamper|
      bootcamper.update_attribute("program_id", program.id)
    end
  end
end
