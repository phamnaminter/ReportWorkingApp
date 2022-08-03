RSpec.shared_examples "not logged for get method" do |action, params|
  context "when not login" do
    before {get action, params: params}

    it "redirect login page" do
      expect(response).to redirect_to login_path
    end
  end
end

RSpec.shared_examples "not logged for other method" do
  context "when not login" do
    it "redirect login page" do
      expect(response).to redirect_to login_path
    end
  end
end

RSpec.shared_examples "find a department" do |action, params|
  context "when department is not found" do
    before do
      init = {department_id: -1}
      init.merge!(params) if params
      get action, params: init
    end

    it "redirect root page" do
      expect(response).to redirect_to root_path
    end

    it "set flash danger" do
      expect(controller).to set_flash[:danger].to(/Unvaiable Data/)
    end
  end

  RSpec.shared_examples "find managers" do |action, params|
    before do
      init = {department_id: department_2}
      init.merge!(params) if params
      get action, params: init
    end

    context "when manager is not found" do
      it "redirect root page" do
        expect(response).to redirect_to root_path
      end

      it "set flash danger" do
        expect(controller).to set_flash[:danger].to(/Department does not have any managers/)
      end
    end
  end

  context "when department is exist" do
    it "department has value" do
      init = {department_id: department.id}
      init.merge!(params) if params
      get action, params: init
      assert_equal department, assigns(:department)
    end
  end

  RSpec.shared_examples "find a relationship" do |action, params|
    context "when relationship is not found" do
      before do
        log_in user_singe
        init = {department_id: department.id}
        init.merge!(params) if params
        get action, params: init
      end

      it "redirect root page" do
        expect(response).to redirect_to root_path
      end

      it "set flash danger" do
        expect(controller).to set_flash[:danger].to(/Relationship not found/)
      end
    end
  end

  RSpec.shared_examples "find a report" do |action, params|
    before do
      init = {id: -1}
      init.merge!(params) if params
      get action, params: init
    end

    context "when report is not found" do
      it "redirect root page" do
        expect(response).to redirect_to root_path
      end

      it "set flash danger" do
        expect(controller).to set_flash[:danger].to(/Unvaiable Data/)
      end
    end

    context "when report is exist" do
      it "report has value" do
        init = {id: report_1.id, department_id: department.id}
        init.merge!(params) if params
        get action, params: init
        assert_equal report_1, assigns(:report)
      end
    end
  end
end
