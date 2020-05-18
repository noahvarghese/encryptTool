class DecryptController < ApplicationController
    skip_before_action :verify_authenticity_token
    def decrypt

        # Set string to decrypt
        encrypted_string = CGI::unescapeHTML(params[:encryptedString])

        # Start decryption
        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt

        # Get key to decrypt string
        file = File.open("config/master.key")
        key = file.read
        decipher.key = key
        file.close

        # Checks if initialization vector is set
        file = File.open('config/iv.key')
        utf8_iv = file.read
        decipher_iv = Base64.decode64(utf8_iv.encode('ascii-8bit'))

        ascii_encrypted_string = Base64.decode64(encrypted_string.encode('ascii-8bit'))

        file.close

        begin
            # Decrypt string
            decypted_string = decipher.update(ascii_encrypted_string) + decipher.final
            URL_encoded = CGI::escape(decypted_string)
            URL_decoded = CGI::unescapeHTML(URL_encoded)
            status = { :success => true, :result => decypted_string, :result_URL_encoded => URL_encoded, :result_URL_decoded => URL_decoded }
        rescue => exception
            status= { :success => false }
        end
        
        render plain: JSON.generate(status)
    end
end
