module Plans
  class BootstrapWithAi
    InvalidWaml = Class.new(StandardError)
    CreationFailed = Class.new(StandardError)

    def initialize(plan, application_description)
      @plan = plan
      @application_description = application_description
    end

    def call
      begin
        waml_application = ::WamlToRails::Definition.new(waml_json.deep_symbolize_keys)

        ActiveRecord::Base.transaction do
          # Create models, columns, and indices
          waml_application.database.schema.each do |schema_model|
            model_name = schema_model.table.classify
            model = @plan.db_models.create!(name: model_name)

            schema_model.columns.each do |schema_column|
              if %w[id created_at updated_at].exclude?(schema_column.name)
                model.columns.create!(name: schema_column.name, field_type: schema_column.type)
              end
            end

            schema_model.indices.each do |schema_index|
              column_ids = schema_index.columns.map { |column_name| model.columns.find_by(name: column_name)&.id }

              next if column_ids.include?(nil)

              model.indices.create!(is_unique: schema_index.unique, column_ids: column_ids)
            end
          end

          waml_application.database.relationships.each do |schema_association|
            if %w[has_many has_one].include?(schema_association.type)
              source_model = @plan.db_models.find_by!(name: schema_association.source.classify)
              target_model = @plan.db_models.find_by!(name: schema_association.destination.classify)

              source_model.associations.create!(
                destination_database_schema_model: target_model,
                connection_type: "#{schema_association.type}_assoc",
                connection_options: {
                  'optional' => !schema_association.required
                }
              )
            end
          end

          waml_application.authentication.each do |schema_authentication|
            @plan.authentications.create!(
              options: schema_authentication.features.map { |f| [f, 'on'] }.to_h,
              name: schema_authentication.table,
              database_schema_model_id: @plan.db_models.find_or_create_by!(name: schema_authentication.table.classify).id
            )
          end
        end

        @plan.prompts_histories.create!(
          prompt: @application_description,
          failed: false,
          llm_waml: waml_json.to_json
        )
      rescue Dry::Struct::Error => e
        @plan.prompts_histories.create!(
          prompt: @application_description,
          failed: true,
          llm_waml: waml_json.to_json
        )

        raise InvalidWaml
      rescue => e
        puts e.backtrace.inspect
        @plan.prompts_histories.create!(
          prompt: @application_description,
          failed: true,
          llm_waml: waml_json.to_json
        )

        Sentry.capture_exception(e)

        raise CreationFailed
      end
    end

    private

    def waml_json
      @waml_json ||= ::GenerateWamlWithClaude.call(@application_description)
    end
  end
end
