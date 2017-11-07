load "spreadsheet_validation_service.rb"

class SpreadsheetService
  include SpreadsheetValidationService
  def initialize(file)
    @sheet = Roo::Spreadsheet.open(file)
  end

  def get_data
    @sheet
  end

  def get_check_list
    [
      "First Name",
      "Last Name",
      "Email",
      "Gender",
      "LFA"
    ]
  end

  def validate_spreadsheet(spreadsheet_data)
    error = {}
    error[:headers] = []
    error[:rows] = []
    error[:email] = []
    error[:error] = true

    invalid_headers_missing = validate_headers
    if invalid_headers_missing[:invalid].count > 0
      error[:headers] = invalid_headers_missing[:invalid]
    end
    return error if invalid_headers_missing[:invalid].count > 0

    valid_data = validate_body(spreadsheet_data)
    if valid_data[:error_rows] && valid_data[:error_rows].count > 0
      error[:rows] = valid_data[:error_rows]
    end

    if valid_data[:error_email] && valid_data[:error_email].count > 0
      error[:email] = valid_data[:error_email]
    end

    return error if error[:headers].count > 0 ||
                    error[:rows].count > 0 ||
                    error[:email].count > 0
    {
      error: false,
      bootcampers: valid_data[:bootcampers]
    }
  end

  def camper_params(row, data)
    {
      camper_id: Bootcamper.generate_camper_id,
      first_name: row[0].value,
      last_name: row[1].value,
      email: row[2].value,
      city: data[1],
      country: data[0],
      cycle: data[2],
      gender: row[3].value.titleize,
      week_one_lfa: row[4] ? row[4].value.strip : "",
      week_two_lfa: "",
      decision_one: "In Progress",
      decision_two: "Not Applicable"
    }
  end

  def get_error_rows(invalid_fields)
    columns = []
    invalid_fields.each do |row|
      columns.push(get_check_list[row.column - 1])
    end

    {
      row: invalid_fields[0].row,
      columns: columns
    }
  end
end
