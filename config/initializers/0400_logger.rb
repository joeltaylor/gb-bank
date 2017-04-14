Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}.log"))

Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
