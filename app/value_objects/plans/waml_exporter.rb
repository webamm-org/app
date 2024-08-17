module Plans
  class WamlExporter
    def self.call(plan)
      db_definition = {
        'relationships' => [],
        'schema' => [],
        'crud' => []
      }

      plan.db_models.find_each do |model|
        model_definition, relationships = ::Plans::WamlExporters::DatabaseSchema::Model.to_waml(model)
        db_definition['schema'] << model_definition
        db_definition['relationships'] |= relationships
      end

      authentications = plan.authentications.map do |authentication|
        {
          'table' => authentication.model.name.underscore.pluralize,
          'features' => authentication.options.keys
        }
      end

      plan.resources.each do |resource|
        db_definition['crud'] << ::Plans::WamlExporters::DatabaseSchema::Resource.new(resource).to_waml
      end

      {
        'database' => {
          # TODO: reflect other database types
          'engine' => 'postgresql',
          'relationships' => db_definition['relationships'],
          'schema' => db_definition['schema'],
          'crud' => db_definition['crud']
        },
        'authentication' => authentications
      }
    end
  end
end
