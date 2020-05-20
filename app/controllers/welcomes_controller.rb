class WelcomesController < ApplicationController
  before_action :set_welcome, only: [:show, :edit, :update, :destroy]

  # GET /welcomes
  # GET /welcomes.json
  def index
  end

  def crypto

    url = URI.parse("http://" + request.host + params[:action])
    req = Net::HTTP::Post.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {
      |http|
      http.request(req)
    }


    res = JSON.parse(res)
    @success = res["success"]

    if @success
      @result = res["result"]
      @result_URL_encoded = res["result_URL_encoded"]
      @result_URL_decoded = res["result_URL_decoded"]
    else
      @error = res["error"]
    end

    render "index"
    
  end
end
