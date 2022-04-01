require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  # ここの部分だけはコメントアウト
  # it "ユーザー単位では重複したプロジェクト名を許可しない" do
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name: "Tester",
  #     email: "joetester@example.com",
  #     password: "dottle-nouveau-pavilion-tights-furze",
  #   )

  #   user.projects.create(
  #     name: "Test Project",
  #   )
    
  #   new_project = user.projects.build(
  #     name: "Test Project",
  #   )

  #   new_project.valid?
  #   expect(new_project.errors[:name]).to include("has already been taken")
  # end

  # it "二人のユーザーが同じ名前を使うことは許可する" do
  #   user = User.create(
  #     first_name: "Joe",
  #     last_name: "Tester",
  #     email: "joetester@example.com",
  #     password: "dottle-nouveau-pavilion-tights-furze",
  #   )
    
  #   user.projects.create(
  #     name: "Test Project",
  #   )

  #   other_user = User.create(
  #     first_name: "Jane",
  #     last_name: "Tester",
  #     email: "janetester@example.com",
  #     password: "dottle-nouveau-pavilion-tights-furze",
  #   )

  #   other_project = other_user.projects.build(
  #     name: "Test Project",
  #   )

  #   expect(other_project).to be_valid
  # end
end

describe "遅延ステータス" do
  it "締め切りが過ぎていれば遅延していること" do
    project = FactoryBot.create(:project, :due_yesterday)
    expect(project).to be_late
  end
  
  it "締め切りが今日ならスケジュールどおりである" do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).to_not be_late
  end
  
  it "締め切りが未来なら予定通りであること" do
    project = FactoryBot.create(:project, :due_tomorrow)
    expect(project).to_not be_late
  end
  
  it "たくさんのメモが付いていること" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
