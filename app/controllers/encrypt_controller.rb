class EncryptController < ApplicationController
    skip_before_action :verify_authenticity_token

    def encrypt
        string = params[:string]

        # Start encryption
        cipher = OpenSSL::Cipher::AES256.new :CBC
        cipher.encrypt

        # Checks if initialization vector is set
        file = File.open('config/iv.key')
        utf8_iv = file.read
        iv = Base64.decode64(utf8_iv.encode('ascii-8bit'))

        # Create intilization vector if does not exists
        if iv.empty?
            iv = decipher.random_iv
            # Save iv for later use
            File.write('config/iv.key', Base64.encode64(iv).encode('utf-8'))
        end

        # Get key to decrypt string
        file = File.open("config/master.key")
        cipher.key = file.read
        file.close

        encrypted_string = cipher.update(string) + cipher.final

        render plain: encrypted_string
    end
end
