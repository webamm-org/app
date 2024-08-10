module DatabaseSchemaAssociations
  class CreationCallback
    def self.call(database_schema_association)
      if database_schema_association.has_many_and_belongs_to_many_assoc?
        plan = database_schema_association.source_database_schema_model.plan
        source_model = database_schema_association.source_database_schema_model
        destination_model = database_schema_association.destination_database_schema_model
        name_elements = [source_model.name, destination_model.name].sort

        connection_model = plan.db_models.create!(
          name: "#{name_elements.first.pluralize}#{name_elements.last}",
          options: {
            'habtm' => true,
            'source_model_id' => source_model.id,
            'destination_model_id' => destination_model.id
          }
        )

        existing_options = database_schema_association.connection_options
        existing_options['habtm_model_id'] = connection_model.id

        database_schema_association.update!(connection_options: existing_options)

        # create association for the second model in connection
        destination_assoc = DatabaseSchema::Association.create!(
          connection_type: 'has_many_and_belongs_to_many_assoc',
          source_database_schema_model_id: destination_model.id,
          destination_database_schema_model_id: source_model.id,
          connection_options: {
            'habtm_model_id' => connection_model.id
          }
        )

        { connection_model: connection_model, connection_assoc: destination_assoc }
      elsif database_schema_association.has_many_assoc? || database_schema_association.has_one_assoc?
        assoc_options = {}

        assoc_options['optional'] = '1' if database_schema_association.connection_options.key?('optional')

        database_schema_association.destination_database_schema_model.associations.create!(
          connection_type: 'belongs_to_assoc',
          destination_database_schema_model_id: database_schema_association.source_database_schema_model_id,
          connection_options: assoc_options
        )

        {}
      end
    end
  end
end
