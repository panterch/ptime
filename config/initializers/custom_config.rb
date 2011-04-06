APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/custom_config.yml")[Rails.env]
