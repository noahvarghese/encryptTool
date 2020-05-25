class WelcomesController < ApplicationController

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

  end

end
