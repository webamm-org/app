module Plans
  class WamlExporter
    def self.call(plan)
      db_definition = {
        'relationships' => [],
        'schema' => []
      }

      plan.db_models.find_each do |model|
        model_definition, relationships = ::Plans::WamlExporters::DatabaseSchema::Model.to_waml(model)
        db_definition['schema'] << model_definition
        db_definition['relationships'] |= relationships
      end

      {
        'database' => {
          # TODO: reflect other database types
          'engine' => 'postgresql',
          'relationships' => db_definition['relationships'],
          'schema' => db_definition['schema']
        }
      }
    end
  end
end
