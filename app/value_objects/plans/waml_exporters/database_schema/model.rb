module Plans
  module WamlExporters
    module DatabaseSchema
      class Model
        def self.to_waml(model)
          table_name = model.name.underscore.pluralize
          relationships = []

          model_definition = {
            'table' => table_name,
            'columns' => [],
            'indices' => []
          }

          model.indices.find_each do |index|
            model_definition['indices'] << ::Plans::WamlExporters::DatabaseSchema::Index.to_waml(index)
          end

          model.columns.find_each do |column|
            model_definition['columns'] << ::Plans::WamlExporters::DatabaseSchema::Column.to_waml(column)
          end

          model.associations.find_each do |association|
            association_definition = ::Plans::WamlExporters::DatabaseSchema::Association.to_waml(table_name, association)
            next if association_definition.nil?

            relationships << association_definition
          end

          [model_definition, relationships]
        end
      end
    end
  end
end
