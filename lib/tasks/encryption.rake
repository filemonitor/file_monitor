namespace :encryption do
  # Generate encryption key for the first time
  task :init do
    new_key = SymmetricEncryption::Key.new(cipher_name: 'aes-256-cbc')

    raise "Cannot generate key for the first time since one already exists" if SecretConfig.key?('symmetric_encryption/key')

    SecretConfig.set('symmetric_encryption/key', Base64.strict_encode64(new_key.key))
    SecretConfig.set('symmetric_encryption/iv', Base64.strict_encode64(new_key.iv))
    SecretConfig.set('symmetric_encryption/version', 1)

    puts "Successfully created initial random keys for #{application}"
  end
end

#TODO ask Reid if I need other parts of this