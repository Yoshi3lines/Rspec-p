require 'rails_helper'

describe User do
  it "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end

RSpec.describe User, type: :model do
  it "姓、名、メール、パスワードがあれば有効な状態であること" do
    user = User.new(
      first_name: "Aaron",
      last_name: "Summer",
      email: "tester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
    expect(user).to be_valid
  end

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "ユーザーのフルネームを文字列として返すこと" do
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end

  it "複数のユーザーで同じアドレスを登録してみる（シーケンスをテスト）" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(:true).to be_truthy
  end

  it "アカウントが作成された時にウェルカムメッセージを送信すること" do
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it "ジオコーディングを実行すること", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).
      from(nil).
      to("New York City, New York, US")
  end
end


# RSpec.describe User, type: :model do 変更前p156
#   it "姓、名、メール、パスワードがあれば有効な状態であること" do
#     user = User.new(
#       first_name: "Aaron",
#       last_name: "Summer",
#       email: "tester@example.com",
#       password: "dottle-nouveau-pavilion-tights-furze",
#     )
#     expect(user).to be_valid
#   end

#   it "名がなければ無効な状態であること" do
#     user = FactoryBot.build(:user, first_name: nil)
#     user.valid?
#     expect(user.errors[:first_name]).to include("can't be blank")
#   end

#   it "姓がなければ無効な状態であること" do
#     user = FactoryBot.build(:user, last_name: nil)
#     user.valid?
#     expect(user.errors[:last_name]).to include("can't be blank")
#   end

#   it "メールアドレスがなければ無効な状態であること" do
#     user = FactoryBot.build(:user, email: nil)
#     user.valid?
#     expect(user.errors[:email]).to include("can't be blank")
#   end

#   it "重複したメールアドレスなら無効な状態であること" do
#     FactoryBot.create(:user, email: "aaron@example.com")
#     user = FactoryBot.build(:user, email: "aaron@example.com")
#     user.valid?
#     expect(user.errors[:email]).to include("has already been taken")
#   end

#   it "ユーザーのフルネームを文字列として返すこと" do
#     user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
#     expect(user.name).to eq "John Doe"
#   end

#   it "複数のユーザーで同じアドレスを登録してみる（シーケンスをテスト）" do
#     user1 = FactoryBot.create(:user)
#     user2 = FactoryBot.create(:user)
#     expect(:true).to be_truthy
#   end
# end
