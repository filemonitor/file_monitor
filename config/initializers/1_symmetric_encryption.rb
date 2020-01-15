# frozen_string_literal: true

# Need to set the cipher before the application is loaded and gem files initialized
# to avoid warning about config file not present
SymmetricEncryption.cipher =
  SymmetricEncryption::Cipher.new(
    key: SecretConfig.fetch('symmetric_encryption/key', encoding: :base64),
    iv: SecretConfig.fetch('symmetric_encryption/iv', encoding: :base64),
    version: SecretConfig.fetch('symmetric_encryption/version', type: :integer)
  )
