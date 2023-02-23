class GithubsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    debugger

    @payload = JSON.parse(params[:payload])

    case request.env["HTTP_X_GITHUB_EVENT"]
    when "pull_request"
      if @payload["action"] == "opened"
        process_pull_request(@payload["pull_request"])
      end
    end
  end

  private

  def process_pull_request pull_request
    @client.create_status(pull_request["base"]["repo"]["full_name"], pull_request["head"]["sha"], "pending")

    sleep 2 # do busy work...

    @client.create_status(pull_request["base"]["repo"]["full_name"], pull_request["head"]["sha"], "success")
    puts "Pull request processed!"
  end
end
