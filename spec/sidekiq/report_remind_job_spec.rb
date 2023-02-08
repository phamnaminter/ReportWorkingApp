require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.inline!

RSpec.describe ReportRemindJob, type: :job do
  let!(:user) {FactoryBot.create :user}
  let!(:user_singe) {FactoryBot.create :user, role: :normal}
  let!(:department) {FactoryBot.create :department}
  let!(:relationship_user) {FactoryBot.create :relationship, user_id: user.id, department_id: department.id, role_type: :employee}
  let!(:relationship_manager) {FactoryBot.create :relationship, user_id: user_singe.id, department_id: department.id, role_type: :employee}
  let!(:report_1) {FactoryBot.create :report, from_user_id: user.id, department_id: department.id, report_date: Time.zone.now}

  describe "Confirm notify to correct user" do
    before {ReportRemindJob.perform_async}

    context "When user was reported" do
      it "User is not receive notify" do
        expect(Notify.where(user_id: user.id, msg: "Let is create to day report of #{department.id}").size).to eq(0)
      end
    end

    context "When user was not reported" do
      it "User receive notify" do
        expect(Notify.where(user_id: user_singe.id, msg: "Let is create to day report of #{department.name}").size).to eq(1)
      end
    end
  end
end
