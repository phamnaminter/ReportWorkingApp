require "rails_helper"
include SessionsHelper

RSpec.describe ReportsController, type: :controller do

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
  let!(:report_3) {FactoryBot.create :report, from_user_id: user.id, to_user_id: user_manager.id, department_id: department.id, report_status: :confirmed}
  let!(:report_4) {FactoryBot.create :report, from_user_id: user_singe.id, to_user_id: user_manager.id, department_id: department.id}

  describe "GET #index" do
    it_behaves_like "not logged for get method", "index"

    context "when user logged" do
      context "with normal user" do
        before do
          get :index
        end

        context "when has reports" do
          it "with reports for normal user" do
            log_in user
            params = {
              department_id: department.id,
            }
            get :index, params: params
            expect(assigns(:reports).pluck(:id)).to eq([report_1.id, report_2.id, report_3.id])
          end

          it "with filter reports" do
            log_in user
            params = {
              department_id: department.id,
              filter: {
                id: report_1.id,
                department: nil,
                name: nil,
                date_created: nil,
                date_reported: nil,
                status: nil
              }
            }
            get :index, params: params
            expect(assigns(:reports).pluck(:id)).to eq([report_1.id])
          end

          it "with reports for manager" do
            log_in user_manager
            params = {department_id: department.id}
            get :index, params: params
            expect(assigns(:reports).pluck(:id)).to eq([report_1.id, report_2.id, report_3.id, report_4.id])
          end
        end

        it "render index" do
          log_in user
          params = {department_id: department.id}
          get :index, params: params
          expect(response).to render_template :index
        end
      end

      context "with invalid user login" do
        before {log_in user_singe}
        it_behaves_like "find a department", :index
        it_behaves_like "find a relationship", :index
      end
    end
  end

  describe "GET show/:id" do
    let!(:comment_1) {FactoryBot.create :comment, user_id: user.id, report_id: report_1.id}
    let!(:comment_2) {FactoryBot.create :comment, user_id: user.id, report_id: report_1.id}
    let!(:comment_3) {FactoryBot.create :comment, user_id: user.id, report_id: report_1.id}

    it_behaves_like "not logged for other method" do
      before do
        get :show, params: {id: report_1.id}
      end
    end

    context "when user logged" do
      before {log_in user}

      it_behaves_like "find a report", :show

      context "when found" do
        it "show comments latest" do
          get :show, params: {id: report_1.id, department_id: department.id}
          expect(assigns(:comments).pluck(:id)).to eq([comment_1.id,comment_2.id, comment_3.id])
        end
      end

      it "comment should constructor" do
        get :show, params: {id: report_1.id, department_id: department.id}
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it "render show" do
        get :show, params: {id: report_1.id, department_id: department.id}
        expect(response).to render_template :show
      end
    end
  end

  describe "GET #new" do
    it_behaves_like "not logged for other method" do
      before {get :new}
    end

    context "when user logged" do
      before {log_in user}

      it_behaves_like "find a department", :new
      it_behaves_like "find managers", :new

      it "should be constructor" do
        get :new, params: {department_id: department.id}
        expect(assigns(:report)).to_not eq nil
        expect(assigns(:report)).to be_a_new(Report)
      end

      it "render new" do
        get :new, params: {department_id: department.id}
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    it_behaves_like "not logged for other method" do
      before do
        post :create, params: {
          report: { report_date: "test", today_problem: "test" }
        }
      end
    end

    context "when user logged" do
      before {log_in user}

      context "When create success" do
        before do
          post :create, params: {
            department_id: department.id,
            report: { to_user_id: user_manager.id, report_date: "2022-08-12",
              today_plan: "test 1", today_work: "test 2", today_problem: "test 3", tomorow_plan: "test 4" }
          }
        end

        it "build report success" do
          expect(assigns(:report)).to eq(Report.last)
        end

        it "show flash success" do
          expect(flash[:success]).to eq "Create report successfully"
        end

        it "redirect to root path" do
          expect(response).to redirect_to root_path
        end
      end

      context "create report failed" do
        before do
          log_in user
          post :create, params: {department_id: department.id, report: {wrong: "wrong_param"}}
        end

        it "show flash danger" do
          expect(flash.now[:danger]).to eq "Create report failed"
        end

        it "render templates new" do
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "GET #edit" do
    it_behaves_like "not logged for get method", "edit", {id: 1}

    context "when user logged" do
      before {log_in user}

      let(:params) do
        {
          id: report_1.id,
          department_id: department.id,
        }
      end

      it_behaves_like "find a department", :edit, {id: 1}
      it_behaves_like "find a report", :edit

      it "render edit" do
        get :index, params: params
        expect(response).to render_template :index
      end
    end
  end

  describe "PATCH update/:id" do
    it_behaves_like "not logged for other method" do
      before do
        put :update, params: {
          department_id: department.id, id: report_1.id,
          report: { to_user_id: user_manager.id, report_date: "2022-08-12",
          today_plan: "test 1 edit", today_work: "test 2 edit", today_problem: "test 3 edit", tomorow_plan: "test 4 edit" }
        }
      end
    end

    context "when user logged" do
      before {log_in user}

      context " when update success" do
        before do
          put :update, params: {
            department_id: department.id, id: report_1.id,
            report: { to_user_id: user_manager.id, report_date: "2022-08-13",
            today_plan: "test 1 edit", today_work: "test 2 edit", today_problem: "test 3 edit", tomorow_plan: "test 4 edit" }
          }
        end

        it "update success" do
          expect(assigns(:report)).to eq(Report.find(report_1.id))
        end

        it "show success message" do
          expect(flash.now[:success]).to eq "Update Successfully"
        end

        it "redirect to department reports path" do
          expect(response).to redirect_to department_reports_path(report_1.department_id)
        end
      end

      context "when update failed" do
        before do
          patch :update, params: {
            department_id: department.id, id: report_1.id,
            report: { to_user_id: nil, report_date: "2022-08-13",
            today_plan: "test 1 edit", today_work: "test 2 edit", today_problem: "test 3 edit", tomorow_plan: "test 4 edit" }
          }
        end

        it "show failure message" do
          expect(flash.now[:danger]).to eq "Update Failure"
        end

        it "render edit templates" do
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "not logged for other method" do
      before do
        patch :destroy, params: {id: 1}
      end
    end

    context "when user logged" do
      before {log_in user}

      it "delete success" do
        patch :destroy, params: {id: report_1.id}
        expect(flash[:success]).to eq "Delete Successfully"
      end

      it "delete report of another people" do
        patch :destroy, params: {id: report_4.id}
        expect(flash[:danger]).to eq "Permission denied"
      end

      it "delete unverifyed report" do
        patch :destroy, params: {id: report_3.id}
        expect(flash[:danger]).to eq "Can not delete unverifyed report"
      end

      it "delete failed" do
        allow_any_instance_of(Report).to receive(:destroy).and_return(false)
        patch :destroy, params: {id: report_1.id}
        expect(flash[:danger]).to eq "Delete Failure"
      end
    end
  end

  describe "PATCH approve/:id" do
    it_behaves_like "not logged for other method" do
      before do
        patch :update, params: {
          status: "manager",
          id: report_1.id
        }
      end
    end

    context "when user logged" do
      before {log_in user_manager}

      it "when confirm report success" do
        patch :approve, params: {
          status: "confirmed",
          id: report_1.id,
          department_id: department.id
        }
        expect(flash[:success]).to eq "Update Success"
      end

      it "when confirm report failed" do
        patch :approve, params: {
          status: "Nil",
          id: report_1.id,
          department_id: department.id
        }
        expect(flash[:danger]).to eq "Update Failure"
      end
    end
  end
end
