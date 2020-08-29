<p align="center">
  <a href="https://www.gatsbyjs.org">
    <img alt="Noah" src="https://noahvarghese.me/favicon.ico" width="60" />
  </a>
</p>
<h1 align="center">
  CryptoTool
</h1>

Secure your development process, and never store your passwords in code.
Can use either the php branch, or master (ruby)

## 🚀 Quick start

1. **Launch Tool**

  Clone repository to web server.
  
  ```shell
  # Make sure this is your web server and the path yoiu will be accessing it from
  # Or move the contents after download
  git clone https://github.com/noahvarghese/cryptoTool
  ```
  
1. **Secure Password**

  - Navigate to url pointing to app
  - Paste in password to be encrypted
  - Make sure 'encrypt' is selected
  - Take result url encoded, and paste into config file for your project

1. **Using Encrypted Password**
 
  When going to use the encrypted password
  
  - Send post request to tool with params: 
      - crypt: {encrypt|descrypt}
      - string: {encryptedString}
      
  - Result that comes back will be the decrypted string. continue using
