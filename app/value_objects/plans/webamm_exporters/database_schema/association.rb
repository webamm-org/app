module Plans
  module WebammExporters
    module DatabaseSchema
      class Association
        def self.to_webamm(table_name, association)
          base_def = {
            'type' => association.connection_type.gsub('_assoc', ''),
            'required' => !association.connection_options.key?('optional'),
            'source' => table_name,
            'options' => {}
          }

          unless association.parent_children_assoc?
            base_def['destination'] = association.destination_database_schema_model.name.underscore.pluralize 
          end

          return base_def unless association.has_many_and_belongs_to_many_assoc?

          base_def['options'] = {
            'habtm_table' => association.source_database_schema_model.plan.db_models.find(association.connection_options['habtm_model_id']).name.underscore.pluralize
          }

          base_def
        end
      end
    end
  end
end
