class GithubsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @payload = JSON.parse(params[:payload])

    case request.env["HTTP_X_GITHUB_EVENT"]
    when "pull_request"
      if @payload["action"] == "opened" || @payload["action"] == "reopened"
        process_pull_request(@payload["pull_request"])
      end
    end
  end

  private

  def process_pull_request pull_request
    @client ||= Octokit::Client.new(access_token: "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")

    @client.create_status(pull_request["base"]["repo"]["full_name"], pull_request["head"]["sha"], "pending")

    # sleep 2 # do busy work...

    # @client.create_status(pull_request["base"]["repo"]["full_name"], pull_request["head"]["sha"], "success")

  end
end
