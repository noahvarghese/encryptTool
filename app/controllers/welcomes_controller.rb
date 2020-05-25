class WelcomesController < ApplicationController
  before_action :set_welcome, only: [:show, :edit, :update, :destroy]

  # GET /welcomes
  # GET /welcomes.json
  def index

    if params.include?(:password) && params.include?(:crypt)

      port = 3000
      
      uri = URI("http://" + request.host + ":" + port.to_s + "/" + params[:crypt])
  
      request_body = { 'string' => params[:password] }
  
      res = Net::HTTP.post_form(uri, request_body)
      
      results = JSON.parse(res.body)
  
      @success = results['success']
  
      if @success then
        @string = results['result']
        @string_URL_encoded = results['result_URL_encoded']
        @string_URL_decoded = results['result_URL_decoded']
      else
        @error = results['error']
      end
    end
    puts @string
    puts @error
    render "index"
  end

  def crypto

    # return port to 80 on deployment
    port = 3000
    uri = URI.parse("http://" + request.host + ":" + port.to_s + "/" + params[:crypt])
    header = {'Content-type': 'text/json'}

    http = Net::HTTP.new(uri.host, uri.port)

    request_body = { 'string' => params[:password] }

    request = Net::HTTP::Post.new(uri.request_uri, header)

    request.body = request_body.to_json

    response = http.request(request)

    #status = JSON.parse(response.body)

    puts JSON.parse(response.body)

    #puts status



    #puts status

    #puts "Sent request."

    #res = Net::HTTP.post_form(uri, request_body)
    #puts "End request."
    #puts JSON.parse(res.body)

    #res = JSON.parse(res.body)

    #puts "Before variables."
    #@success = res["success"]
    #@status = status

    #if @success
    #  @result = res["result"]
    #  @result_URL_encoded = res["result_URL_encoded"]
    #  @result_URL_decoded = res["result_URL_decoded"]
    #else
    #  @error = res["error"]
    #end

    render "index"
    
  end
end
