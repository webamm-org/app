module Plans
  class BootstrapWithAi
    def initialize(plan, application_description)
      @plan = plan
      @application_description = application_description
    end

    def call
      ActiveRecord::Base.transaction do
        # Create models, columns, and indices
        waml_json['database']['schema'].each do |model_attrs|
          model_name = model_attrs['table'].classify
          model = @plan.db_models.create!(name: model_name)

          model_attrs['columns'].each do |column_attrs|
            if %w[id created_at updated_at].exclude?(column_attrs['name'])
              model.columns.create!(name: column_attrs['name'], field_type: column_attrs['type'])
            end
          end

          model_attrs['indices'].each do |index_attrs|
            column_ids = index_attrs['columns'].map { |column_name| model.columns.find_by!(name: column_name).id }
            model.indices.create!(is_unique: index_attrs['unique'], column_ids: column_ids)
          end
        end

        waml_json['database']['relationships'].each do |association_attrs|
          if %w[has_many has_one].include?(association_attrs['type'])
            source_model = @plan.db_models.find_by!(name: association_attrs['source'].classify)
            target_model = @plan.db_models.find_by!(name: association_attrs['destination'].classify)

            source_model.associations.create!(
              destination_database_schema_model: target_model,
              connection_type: "#{association_attrs['type']}_assoc",
              connection_options: {
                'optional' => !association_attrs['required']
              }
            )
          end
        end
      end
    end

    private

    def waml_json
      @waml_json ||= ::GenerateWamlWithClaude.call(@application_description)
    end
  end
end
