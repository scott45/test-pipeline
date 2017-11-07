require "rails_helper"
require "spec_helper"

describe "Criteria test" do
  before :all do
    @framework1 = create :framework
    @criterium1 = create :criterium
    @framework_criterium1 = create(:framework_criterium, framework: @framework1,
                                                         criterium: @criterium1)

    @framework2 = create :framework
    @criterium2 = create :criterium
    @framework_criterium2 = create(:framework_criterium, framework: @framework2,
                                                         criterium: @criterium2)
  end

  before do
    stub_andelan
    stub_current_session
    visit("/content_management")
    find("li.criteria-tab.tab").click
  end

  after do
    @framework_criterium1.delete
    @framework_criterium2.delete
    @framework1.delete
    @framework2.delete
    @criterium1.delete
    @criterium2.delete
  end

  feature "view criteria tab" do
    scenario "user should see created criteria names" do
      expect(page).to have_content(@criterium1.name)
      expect(page).to have_content(@criterium2.name)
    end

    scenario "user should see criteria descriptions" do
      expect(page).to have_content(@criterium1.description)
      expect(page).to have_content(@criterium2.description)
    end

    scenario "user should see criteria frameworks" do
      framework_name1 = @criterium1.frameworks[0].name
      framework_name2 = @criterium2.frameworks[0].name
      expect(page).to have_content(framework_name1)
      expect(page).to have_content(framework_name2)
    end
  end

  feature "edit criterion" do
    scenario "user should be able to edit criterion info" do
      page.all("i.icon-edit.edit-criterium").first.click
      wait_for_ajax
      within("#criterion-modal") do
        fill_in("criterion", with: @criterium1.name + " Edited")
        click_button("save-criterion")
      end
      expect(page).to have_content(@criterium1.name + " Edited")
    end
  end

  feature "add criterium" do
    scenario "user should be able to create new criterion" do
      page.find("span.icon.menu-open").click
      wait_for_ajax
      page.all("li.admin-item")[1].click
      within("#criterion-modal") do
        fill_in("criterion", with: "New Criterium")
        framework = page.all("div.select-wrapper")[0].click
        framework.find("li:nth-of-type(2)").click
        framework.find("li:nth-of-type(3)").click
        find("#modal-header").click
        fill_in("description", with: "This is a description")
        click_button("save-criterion")
      end
      expect(page).to have_content("Criterion Successfully created")
      expect(page).to have_content("New Criterium")
    end

    scenario "user should not be able to submit blank framework" do
      page.find("span.icon.menu-open").click
      wait_for_ajax
      page.all("li.admin-item")[1].click
      within("#criterion-modal") do
        fill_in("criterion", with: "New Criterium")
        fill_in("description", with: "This is a description")
        click_button("save-criterion")
      end
      expect(page).to have_content("Please select at least one framework")
    end

    scenario "user should not be able to submit blank name" do
      page.find("span.icon.menu-open").click
      wait_for_ajax
      page.all("li.admin-item")[1].click
      within("#criterion-modal") do
        framework = page.all("div.select-wrapper")[0].click
        framework.find("li:nth-of-type(2)").click
        fill_in("description", with: "This is a description")
        find("#modal-header").click
        click_button("save-criterion")
      end
      expect(page).to have_content("Name can't be blank")
    end
  end

  feature "filter criteria" do
    scenario "user should be able to filter by framework" do
      framework = page.find("div.select-wrapper.cms_framework_class").click
      framework.find("li:nth-of-type(2)").click
      wait_for_ajax
      expect(page).to have_content("Technical Skills")
      expect(page).to have_content("Team Skills")
    end
  end

  feature "restrict non admins from edit, delete and add actions" do
    scenario "non admin should not have admin access" do
      click_link("Duyile Oluwatomi")
      click_link("Logout")
      visit("/login")
      stub_andelan_non_admin
      stub_current_session_non_admin
      visit("/content_management")
      find("li.criteria-tab.tab").click
      expect(page).not_to have_selector(".icon-edit.edit-criterium")
      expect(page).not_to have_selector(".icon-delete")
      expect(page).not_to have_selector(".icon_wrapper")
      clear_session
    end
  end
end
