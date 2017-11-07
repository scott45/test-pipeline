require "jwt"

module Helpers
  def stub_current_user(user)
    allow_any_instance_of(ApplicationController).
      to receive(:authentication).and_return(user)
  end

  def stub_andelan
    allow(JWT).to receive(:decode).and_return(
      [
        {
          "UserInfo" => {
            "email" => "oluwatomi.duyile@andela.com",
            "first_name" => "Oluwatomi",
            "last_name" => "Duyile",
            "name" => "Duyile Oluwatomi",
            "andelan" => true,
            "picture" => "",
            "roles" => { "VOF_Admin" => "-KdN3P3b8y3X77X8AcJX" }
          }
        }
      ]
    )
  end

  def stub_andelan_non_admin
    allow(JWT).to receive(:decode).and_return(
      [
        {
          "UserInfo" => {
            "email" => "jane.doe@andela.com",
            "first_name" => "Jane",
            "last_name" => "Doe",
            "name" => "Jane Doe",
            "andelan" => true,
            "picture" => "",
            "roles" => { "Guest" => "-KXGy1EB1oimjQgFim6I" }
          }
        }
      ]
    )
  end

  def stub_non_andelan
    allow(JWT).to receive(:decode).and_return(
      [
        {
          "UserInfo" => {
            "email" => "akinrelesimi@gmail.com",
            "first_name" => "Simi",
            "last_name" => "Akinrele",
            "name" => "Simi Akinrele",
            "andelan" => false,
            "picture" => "",
            "roles" => { "Guest" => "-KXGy1EB1oimjQgFim6I" }
          }
        }
      ]
    )
  end

  def stub_non_andelan_bootcamper(user)
    allow(JWT).to receive(:decode).and_return(
      [
        {
          "UserInfo" => {
            "email" => user.email,
            "first_name" => user.first_name,
            "last_name" => user.last_name,
            "name" => user.name,
            "andelan" => false,
            "picture" => "",
            "roles" => { "Guest" => "-KXGy1EB1oimjQgFim6I" }
          }
        }
      ]
    )
  end

  def stub_current_session
    page.set_rack_session(current_user_info:
    {
      name: "Duyile Oluwatomi",
      admin: false,
      andelan: true,
      picture: ""
    })
    jwt_token = JWT.encode({}, nil, "none")
    page.driver.browser.manage.add_cookie(name: "jwt-token", value: jwt_token)
  end

  def stub_current_session_non_admin
    page.set_rack_session(current_user_info:
    {
      name: "Jane Doe",
      admin: false,
      andelan: true,
      picture: ""
    })
    jwt_token = JWT.encode({}, nil, "none")
    page.driver.browser.manage.add_cookie(name: "jwt-token", value: jwt_token)
  end

  def stub_current_session_bootcamper(user)
    page.set_rack_session(current_user_info:
    {
      name: user.last_name + " " + user.last_name,
      email: user.email,
      admin: false,
      andelan: false,
      picture: ""
    })
    jwt_token = JWT.encode({}, nil, "none")
    page.driver.browser.manage.add_cookie(name: "jwt-token", value: jwt_token)
  end

  def clear_session
    page.set_rack_session(current_user_info: nil)
    page.driver.browser.manage.delete_cookie("jwt-token")
  end

  def stub_camper_progress(value)
    allow(Bootcamper).
      to receive(:update_campers_progress).and_return(value)
  end

  def stub_allow_admin
    allow(controller).to receive_message_chain(:helpers, :admin?)
  end

  def stub_export_csv
    allow(BootcampersCsvService).to receive(:generate_report).
      and_return(csv_header_1)
  end

  def wait_for_ajax
    return unless respond_to?(:evaluate_script)
    wait_until { finished_all_ajax_requests? }
  end

  private

  def finished_all_ajax_requests?
    evaluate_script("!window.jQuery") || evaluate_script("jQuery.active").zero?
  end

  def wait_until(max_execution_time_in_seconds = Capybara.default_max_wait_time)
    Timeout.timeout(max_execution_time_in_seconds) do
      loop do
        if yield
          return true
        else
          sleep(1.00)
          next
        end
      end
    end
  end
end
