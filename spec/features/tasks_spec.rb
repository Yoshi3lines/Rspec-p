require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name: "RSpec tutorial",
      owner: user)
  }
  let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }

  scenario "ユーザーの状態を切り替える", js: true do
    sign_in user
    go_to_project "RSpec tutorial"

    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end
end

#変更前だが正常にスペックができないwebdriverのせい？
# RSpec.feature "Tasks", type: :feature do
#   scenario "ユーザーがタスクの状態を切り替える", js: true do
#     user = FactoryBot.create(:user)
#     project = FactoryBot.create(:project,
#       name: "RSpec tutorial",
#       owner: user)
#     task = project.tasks.create!(name: "Finish RSpec tutorial")

#     visit root_path
#     click_link "Sign in"
#     fill_in "Email", with: user.email
#     fill_in "Password", with: user.password
#     click_button "Log in"

#     click_link "RSpec tutorial"
#     check "Finish RSpec tutorial"

#     expect(page).to have_css "label#task_#{task.id}.completed"
#     expect(task.reload).to be_completed

#     uncheck "Finish RSpec tutorial"

#     expect(page).to_not have_css "label#task_#{task.id}.completed"
#     expect(task.reload).to_not be_completed
#   end
# end
