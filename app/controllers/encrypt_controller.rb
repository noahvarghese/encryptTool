class EncryptController < ApplicationController
    skip_before_action :verify_authenticity_token

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

        encrypted_string = cipher.update(string) + cipher.final

        render plain: CGI::escape(Base64.encode64(encrypted_string).encode('utf-8'))
    end
end
