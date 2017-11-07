module SpreadsheetValidationService
  def validate_headers
    headers = get_data.row(1)
    error_headers = {}
    error_headers[:invalid] = []

    if headers.length < 5
      error_headers[:invalid] = get_check_list - headers
      error_headers[:missing] = true
      return error_headers
    end

    (0..4).each do |index|
      unless get_check_list[index].casecmp(headers[index].to_s).zero?
        error_headers[:invalid].push(get_check_list[index])
      end
    end
    error_headers
  end

  def invalid_row?(row)
    row[0...5].empty? || row[0...5].any? { |info| info.value.nil? }
  end

  def validate_body(spreadsheet_data)
    data = {}
    bootcampers = []
    error_rows = []

    spreadsheet_data[3].each_row_streaming(offset: 1) do |row|
      invalid_fields = validate_fields(row)
      if invalid_fields.blank?
        unless invalid_row?(row)
          bootcampers.push(camper_params(row, spreadsheet_data))
        end
      else
        error_rows.push(get_error_rows(invalid_fields))
      end
    end

    email_duplicates = validate_email(bootcampers)

    data[:bootcampers] = bootcampers
    data[:error_rows] = error_rows if error_rows.count > 0
    data[:error_email] = email_duplicates if email_duplicates.count > 0
    data
  end

  def validate_fields(row)
    error_fields = []
    blank_fields = row.select(&:blank?).length
    if blank_fields == row.length then return error_fields end

    row[0...5].each_with_index do |field, index|
      if [2, 4].include? index
        unless field.value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
          error_fields.push field.coordinate
        end
      end
      if index == 3
        gender = %w(male female)
        gender_field = field.value.downcase unless field.value.nil?
        error_fields.push field.coordinate unless gender.include? gender_field
      elsif field.blank?
        error_fields.push field.coordinate
      end
    end

    error_fields
  end

  def validate_email(bootcampers)
    error_fields = []
    valid_fields = []

    bootcampers.each do |bootcamper|
      if valid_fields.include? bootcamper[:email]
        error_fields << bootcamper[:email]
      else
        valid_fields << bootcamper[:email]
      end
    end

    error_fields
  end
end
