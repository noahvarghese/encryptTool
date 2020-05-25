class EncryptController < ApplicationController
    before_action :set_headers
    skip_before_action :verify_authenticity_token

    def set_headers
        response.headers['Content-Type'] = 'application/json'
    end

    def encrypt

        string = params[:string]

        # Start encryption
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt

        # Checks if initialization vector is set
        file = File.open('config/iv.key')
        iv = file.read

        # Create intilization vector if does not exists
        if iv.empty?
            iv = cipher.random_iv
            # Save iv for later use
            File.write('config/iv.key', Base64.encode64(iv).encode('utf-8'))
        end

        file.close

        # Get key to decrypt string
        file = File.open("config/master.key")
        cipher.key = file.read
        file.close


        begin
            encrypted_ascii = cipher.update(string) + cipher.final
            encrypted_string = Base64.encode64(encrypted_ascii).encode('utf-8')
            url_encoded = CGI::escape(encrypted_string)
            url_decoded = CGI::unescapeHTML(url_encoded)
            status = { :success => true, :result => encrypted_string, :result_URL_encoded => url_encoded, :result_URL_decoded => url_decoded}
        rescue => exception
            status = { :success => false, :error => exception.inspect }
        end

        return render json: status
    end
end
