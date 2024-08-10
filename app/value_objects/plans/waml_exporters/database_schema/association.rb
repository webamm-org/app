module Plans
  module WamlExporters
    module DatabaseSchema
      class Association
        def self.to_waml(table_name,association)
          return if association.belongs_to_assoc?

          {
            'type' => association.connection_type.gsub('_assoc', ''),
            'required' => association.connection_options.fetch('optional', false),
            'source' => table_name,
            # TODO: reflect child parent relationship
            'destination' => association.destination_database_schema_model.name.underscore.pluralize
          }
        end
      end
    end
  end
end
