module Plans
  module Authorization
    class GetOptions
      def initialize(plan:, model_ids:)
        @plan = plan
        @model_ids = model_ids
      end

      def call
        options = []

        @model_ids.each do |model_id|
          model = @plan.db_models.includes(:columns).find(model_id)
          auth_columns = model.columns.for_authorization

          options << [
            model.name,
            model.id
          ]

          auth_columns.each do |column|
            column.options.fetch('enums', []).each do |enum|
              options << [
                "#{enum.capitalize} (#{model.name}##{column.name})",
                "#{model.id}:#{column.id}:#{enum}"
              ]
            end
          end
        end

        options
      end
    end
  end
end
