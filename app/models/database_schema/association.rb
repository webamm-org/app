class DatabaseSchema::Association < ApplicationRecord
  self.table_name = 'database_schema_associations'

  belongs_to :source_database_schema_model, class_name: 'DatabaseSchema::Model', foreign_key: 'source_database_schema_model_id'
  belongs_to :destination_database_schema_model, class_name: 'DatabaseSchema::Model', foreign_key: 'destination_database_schema_model_id', optional: true


  validates :destination_database_schema_model_id, presence: true, unless: :parent_children_assoc?
  validates :connection_type, presence: true

  enum connection_type: { has_one_assoc: 0, has_many_assoc: 1, belongs_to_assoc: 2, has_many_and_belongs_to_many_assoc: 3, parent_children_assoc: 4 }

  def assoc_name
    return 'self referential association' if parent_children_assoc?
  
    destination_name = destination_database_schema_model.name

    if has_many_assoc?
      'has many ' + destination_name.underscore.pluralize.split('_').map(&:downcase).join(' ')
    elsif has_one_assoc?
      'has one ' + destination_name.split('_').map(&:downcase).join(' ')
    elsif belongs_to_assoc?
      'belongs to ' + destination_name.underscore.split('_').map(&:downcase).join(' ')
    elsif has_many_and_belongs_to_many_assoc?
      'has and belongs to many ' + destination_name.underscore.pluralize.split('_').map(&:downcase).join(' ')
    end
  end

  def habtm_with_additional_columns?
    return false unless has_many_and_belongs_to_many_assoc?

    assoc_model = source_database_schema_model.plan.db_models.find(connection_options.fetch('habtm_model_id'))
    assoc_model.columns.any?
  end
end
