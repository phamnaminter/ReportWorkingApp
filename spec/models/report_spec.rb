require "rails_helper"

RSpec.describe Report, type: :model do
  let!(:user) {FactoryBot.create :user}
  let!(:user_manager) {FactoryBot.create :user, role: :normal}
  let!(:user_admin) {FactoryBot.create :user, role: :admin}
  let!(:user_singe) {FactoryBot.create :user, role: :normal}
  let!(:department) {FactoryBot.create :department}
  let!(:department_2) {FactoryBot.create :department}
  let!(:relationship_user) {FactoryBot.create :relationship, user_id: user.id, department_id: department.id, role_type: :employee}
  let!(:relationship_manager) {FactoryBot.create :relationship, user_id: user_manager.id, department_id: department.id, role_type: :manager}
  let!(:report_1) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id}
  let!(:report_2) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id}
  let!(:report_3) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id,
                                     report_status: :confirmed}
  let!(:report_4) {FactoryBot.create :report, from_user_id: user_singe.id, to_user_id: user_manager.id, department_id: department.id}
  let!(:report_5) {FactoryBot.create :report, from_user_id: user_singe.id, to_user_id: user_manager.id, department_id: department_2.id,
                                     report_date: "2022-02-02"}

  describe "Associations" do
    it {is_expected.to belong_to(:from_user).class_name(:User)}
    it {is_expected.to belong_to(:to_user).class_name(:User)}
    it {is_expected.to belong_to(:department)}
    it {is_expected.to have_many(:comments).dependent(:destroy)}
  end

  describe "Validations" do
    subject{FactoryBot.build(:report)}

    context "when field report_date" do
      it {is_expected.to validate_presence_of(:report_date)}
    end

    context "when field today_plan" do
      it {is_expected.to validate_presence_of(:today_plan)}
      it {is_expected.to validate_length_of(:today_plan).is_at_most(Settings.digits.length_255)}
    end

    context "when field today_work" do
      it {is_expected.to validate_presence_of(:today_work)}
      it {is_expected.to validate_length_of(:today_work).is_at_most(Settings.digits.length_255)}
    end

    context "when field today_problem" do
      it {is_expected.to validate_presence_of(:today_problem)}
      it {is_expected.to validate_length_of(:today_problem).is_at_most(Settings.digits.length_255)}
    end

    context "when field tomorow_plan" do
      it {is_expected.to validate_presence_of(:tomorow_plan)}
      it {is_expected.to validate_length_of(:tomorow_plan).is_at_most(Settings.digits.length_255)}
    end
  end

  describe "define enum for category_type" do
    it {is_expected.to define_enum_for :report_status}
  end

  describe "Scope" do

    it "orders by ascending name" do
      expect(Report.sort_created_at.pluck(:id)).to eq([report_1.id, report_2.id, report_3.id, report_4.id, report_5.id])
    end

    it "find by department" do
      expect(Report.by_department(department.name).pluck(:id)).to eq([report_1.id, report_2.id, report_3.id, report_4.id])
    end

    it "find by name" do
      expect(Report.by_name(user.full_name).pluck(:id)).to eq([report_1.id, report_2.id, report_3.id])
    end

    it "find by id" do
      expect(Report.by_id(report_1.id).pluck(:id)).to eq([report_1.id])
    end

    it "find by created_at" do
      expect(Report.by_created_at(report_2.created_at).pluck(:id)).to eq([report_2.id])
    end

    it "find by report_date" do
      expect(Report.by_report_date(report_5.report_date).pluck(:id)).to eq([report_5.id])
    end

    it "find by for_manager" do
      expect(Report.for_manager(department_2.id).pluck(:id)).to eq([report_5.id])
    end

    it "find by for_employee" do
      expect(Report.for_employee(user_singe.id).pluck(:id)).to eq([report_4.id, report_5.id])
    end

    it "find by status" do
      expect(Report.by_status(:confirmed).pluck(:id)).to eq([report_3.id])
    end
  end

  describe "Report status" do
    it "approve report" do
      report_1.approve("confirmed")
      expect(report_1.report_status).to eq("confirmed")
    end

    it "cancel report" do
      report_3.approve("unverifyed")
      expect(report_3.report_status).to eq("unverifyed")
    end
  end

  describe "Accepts nested attributes" do
    it {should accept_nested_attributes_for :comments}


    it "should accept nested attributes for comments" do
      expect {
        report_1.update_attributes(
          "comments_attributes"=>{"0"=>{"description"=>"add new comment",
          "user_id"=>"#{user.id}"}}
        )
      }.to change(Comment, :count).by(1)
    end

    it "should not accept comments with blank description" do
      expect {
        report_1.update_attributes(
          "comments_attributes"=>{"0"=>{"description"=>"",
          "user_id"=>"#{user.id}"}}
        )
      }.to change(Comment, :count).by(0)
    end
  end
end
