module DatabaseSchemaAssociations
  class DestroyCallback
    def self.call(database_schema_association)
      if database_schema_association.belongs_to_assoc?
        ::DatabaseSchema::Association.where(
          source_database_schema_model_id: database_schema_association.destination_database_schema_model_id,
          destination_database_schema_model_id: database_schema_association.source_database_schema_model_id).each do |assoc|
            assoc.destroy!
          end
      elsif database_schema_association.has_many_and_belongs_to_many_assoc?
        source_database_schema_model = database_schema_association.source_database_schema_model
        destination_database_schema_model = database_schema_association.destination_database_schema_model
        habtm_model = source_database_schema_model.plan.db_models.find(database_schema_association.connection_options.fetch('habtm_model_id'))
        
        ActiveRecord::Base.transaction do
          habtm_model.destroy!
          ::DatabaseSchema::Association.where(
            source_database_schema_model_id: database_schema_association.destination_database_schema_model_id,
            destination_database_schema_model_id: database_schema_association.source_database_schema_model_id).each do |assoc|
              assoc.destroy!
            end
        end
      elsif database_schema_association.parent_children_assoc?
        source_database_schema_model = database_schema_association.source_database_schema_model
        parent_id_column = source_database_schema_model.columns.find_by!(name: 'parent_id')
        parent_id_column.destroy!
      end
    end
  end
end
