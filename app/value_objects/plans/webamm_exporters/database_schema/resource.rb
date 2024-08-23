module Plans
  module WebammExporters
    module DatabaseSchema
      class Resource
        def initialize(resource)
          @resource = resource
        end

        def to_webamm
          mappings = {
            'table' => resource_name,
            'actions' => []
          }

          %w[index show create update destroy].each do |action|
            options = @resource.public_send(action + '_options')

            next unless options.key?('include')

            mappings['actions'] << {
              'name' => action,
              'options' => action_options(options)
            }
          end

          mappings
        end

        private

        def action_options(options)
          base_options = {}

          if options.key?('authentication')
            base_options['authentication'] = options.fetch('authentication').map { |auth| find_authentication_name(auth) }
          end

          if options.key?('attributes')
            base_options['model_attributes'] = options.fetch('attributes').map { |attr| find_attribute_name(attr) }
          end

          base_options
        end

        def model
          @model ||= @resource.model
        end

        def plan
          @plan ||= @resource.plan
        end

        def resource_name
          model.name.underscore.pluralize
        end

        def find_attribute_name(id)
          model.columns.find(id).name
        end

        def find_authentication_name(id)
          plan.db_models.find(id).name.underscore.pluralize
        end
      end
    end
  end
end
