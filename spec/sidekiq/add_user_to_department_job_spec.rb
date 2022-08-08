require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.inline!

RSpec.describe AddUserToDepartmentJob, type: :job do
  let!(:user) {FactoryBot.create :user}
  let!(:user_manager) {FactoryBot.create :user, role: :normal}
  let!(:user_admin) {FactoryBot.create :user, role: :admin}
  let!(:user_singe) {FactoryBot.create :user, role: :normal}
  let!(:department) {FactoryBot.create :department}
  let!(:department_2) {FactoryBot.create :department}

  describe "Show message to user" do
    context "when add user to department success" do
      it "show success message" do
        AddUserToDepartmentJob.perform_async([department.id, department_2.id],
          [user_singe.id, user_manager.id], user_admin.id)
        expect(Notify.last.msg).to eq "Add User To Department Success. Please check it work correctly!!!"
      end
    end

    context "when add user to department failed" do
      it "show success message" do
        AddUserToDepartmentJob.perform_async([-1,-2], [-3, -4], user_admin.id)
        expect(Notify.last.msg).to eq "Add User To Department Failure. please try again !!!"
      end
    end
  end

  describe "Confirm data update correctly" do
    context "When update successful" do
      it "Relationship was updated correctly" do
        AddUserToDepartmentJob.perform_async([department.id],
          [user_singe.id, user_manager.id], user_admin.id)
        expect(Relationship.all.pluck(:user_id)) .to eq([user_manager.id, user_singe.id])
      end
    end

    context "When update failed" do
      it "Confirm transaction rollback" do
        AddUserToDepartmentJob.perform_async([department.id, -1],
          [user_singe.id, user_manager.id], user_admin.id)
        expect(Relationship.all.pluck(:user_id)) .to eq([])
      end
    end
  end
end
