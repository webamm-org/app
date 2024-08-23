module Plans
  module WebammExporters
    module DatabaseSchema
      class Model
        def self.to_webamm(model)
          table_name = model.name.underscore.pluralize
          relationships = []

          model_definition = {
            'table' => table_name,
            'columns' => [],
            'indices' => [],
            'options' => {}
          }

          model.indices.find_each do |index|
            model_definition['indices'] << ::Plans::WebammExporters::DatabaseSchema::Index.to_webamm(index)
          end

          model.columns.find_each do |column|
            model_definition['columns'] << ::Plans::WebammExporters::DatabaseSchema::Column.to_webamm(column)
          end

          model.associations.find_each do |association|
            association_definition = ::Plans::WebammExporters::DatabaseSchema::Association.to_webamm(table_name, association)
            next if association_definition.nil?

            relationships << association_definition
          end

          if model.options.key?('use_uuid')
            model_definition['options']['use_uuid'] = true
          end
          
          if model.options.key?('habtm')
            model_definition['options']['habtm'] = true
            model_definition['options']['habtm_tables'] = [
              model.plan.db_models.find(model.options['source_model_id']).name.underscore.pluralize,
              model.plan.db_models.find(model.options['destination_model_id']).name.underscore.pluralize
            ]
          end

          [model_definition, relationships]
        end
      end
    end
  end
end
