class Resource < ApplicationRecord
  belongs_to :model, class_name: "DatabaseSchema::Model", foreign_key: "database_schema_model_id"
  belongs_to :plan

  validates :database_schema_model_id, uniqueness: { scope: :plan_id }

  def actions
    supported_actions = []
    action_names = %w[index show create update destroy]

    action_names.each do |action_name|
      options = public_send(action_name + '_options')

      next unless options.key?('include')

      case action_name
      when 'create'
        supported_actions << 'create'
        supported_actions << 'new'
      when 'update'
        supported_actions << 'update'
        supported_actions << 'edit'
      else
        supported_actions << action_name
      end
    end

    supported_actions
  end
end
