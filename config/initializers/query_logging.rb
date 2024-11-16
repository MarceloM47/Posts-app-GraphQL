Rails.application.config.after_initialize do
    if Rails.env.development?
      Rails.application.config.active_record.query_log_tags_enabled = true
      Rails.application.config.active_record.query_log_tags = [:application, :controller, :action, :job]
    end
end
