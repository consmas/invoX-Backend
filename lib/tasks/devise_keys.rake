# lib/tasks/devise_keys.rake
require "securerandom"
require "yaml"
require "rails"

namespace :credentials do
  desc "Add stable Devise secrets to credentials.yml.enc (run once)"
  task :add_devise_keys do
    require "active_support/encrypted_file"

    content_path = Rails.root.join("config", "credentials.yml.enc")
    key_path     = Rails.application.credentials.key_path
    enc_file     = ActiveSupport::EncryptedFile.new(
      content_path:         content_path,
      key_path:             key_path,
      env_key:              "RAILS_MASTER_KEY",
      raise_if_missing_key: true
    )

    data  = enc_file.read.present? ? YAML.safe_load(enc_file.read) || {} : {}
    added = false

    %w[devise_secret_key devise_jwt_secret_key].each do |label|
      next if data[label]

      data[label] = SecureRandom.hex(64)
      puts "→ added #{label}"
      added = true
    end

    if added
      enc_file.write(data.to_yaml)
      puts "✅ credentials.yml.enc updated."
    else
      puts "🟢 keys already present—nothing to do."
    end
  end
end
