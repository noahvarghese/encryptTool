class DecryptController < ApplicationController
    skip_before_action :verify_authenticity_token
    def decrypt

        # Set string to decrypt
        encryptedString = params[:encryptedString]

        # Start decryption
        decipher = OpenSSL::Cipher::AES256.new :CBC
        decipher.decrypt

        # Checks if initialization vector is set
        file = File.open('config/iv.key')
        utf8_iv = file.read
        iv = Base64.decode64(utf8_iv.encode('ascii-8bit'))
        

        # Create intilization vector if does not exists
        if iv.empty?
            iv = decipher.random_iv
            File.write('config/iv.key', Base64.encode64(iv).encode('utf-8'))
        end

        file.close

        decipher.iv = iv

        # Get key to decrypt string
        file = File.open("config/master.key")
        decipher.key = file.read
        file.close

        # Decrypt string
        decyptedString = decipher.update(encryptedString) + decipher.final
        
        # Display string
        render plain: decyptedString
    end
end
