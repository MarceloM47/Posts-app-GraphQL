Rails.application.config.after_initialize do
    if defined?(GraphQL::Current)
      Rails.application.config.active_record.query_log_tags += [
        { current_graphql_operation: -> { GraphQL::Current.operation_name } },
        { current_graphql_field: -> { GraphQL::Current.field&.path } },
        { current_dataloader_source: -> { GraphQL::Current.dataloader_source_class } }
      ]
    end
end
