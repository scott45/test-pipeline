class BootcampersCsvService
  class << self
    include AssessmentService
    include CsvHeaderService
    include CamperDataService

    attr_accessor :city, :cycle, :decision_one,
                  :decision_two, :week_one_lfa, :week_two_lfa

    def generate_report(filter_params)
      @city = filter_params[:city]
      @cycle = filter_params[:cycle]
      @status_decision1 = filter_params[:decision_one]
      @status_decision2 = filter_params[:decision_two]
      @week_one_lfa = filter_params[:week_one_lfa]
      @week_two_lfa = filter_params[:week_two_lfa]

      set_params

      CSV.generate(headers: true) do |csv|
        csv << CsvHeaderService.csv_header_1
        csv << CsvHeaderService.csv_header_2
        generate_csv_data(csv)
      end
    end

    def set_params
      @city = nil if @city.empty? || @city == "All"
      @cycle = nil if @cycle.empty? || @cycle == "All"
      @status_decision1 = nil if @status_decision1.empty? ||
                                 @status_decision1 == "All"
      @status_decision2 = nil if @status_decision2.empty? ||
                                 @status_decision2 == "All" &&
                                 @status_decision1 != "Advanced"
      @week_one_lfa = nil if @week_one_lfa.empty? || @week_one_lfa == "All"
      @week_two_lfa = nil if @week_two_lfa.empty? || @week_two_lfa == "All"
    end

    def generate_csv_data(csv)
      serial_number = 1
      campers = get_campers
      campers.each do |camper|
        camper_score = CamperDataService.get_camper_score(camper.camper_id)
        camper_data = CamperDataService.get_camper_data(serial_number, camper)
        camper_row = camper_data.concat(camper_score)
        csv << camper_row
        serial_number += 1
      end
    end

    def get_campers
      Bootcamper.all.where build_query
    end

    def build_query
      query = {}
      query[:city] = @city if @city
      query[:cycle] = @cycle if @cycle
      query[:decision_one] = @status_decision1 if @status_decision1
      if @status_decision2 && @status_decision2 != "All"
        query[:decision_two] = @status_decision2
      end
      query[:week_one_lfa] = @week_one_lfa if @week_one_lfa
      query
    end
  end
end
