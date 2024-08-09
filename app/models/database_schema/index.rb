class DatabaseSchema::Index < ApplicationRecord
  self.table_name = 'database_schema_indices'

  belongs_to :model, class_name: 'DatabaseSchema::Model', foreign_key: 'database_schema_model_id'
  has_and_belongs_to_many :columns, class_name: 'DatabaseSchema::Column', dependent: :destroy, foreign_key: 'database_schema_index_id', association_foreign_key: 'database_schema_column_id'

  accepts_nested_attributes_for :columns, allow_destroy: true

  validate :columns_count

  private

  def columns_count
    errors.add(:base, 'You must select at least one column') if column_ids.count.zero?

    duplication_check = model.indices.joins(:columns).where(columns: { id: column_ids }).uniq.any? { |ind| ind.column_ids.size == column_ids.size }

    errors.add(:base, 'You must select unique columns') if duplication_check
  end
end
