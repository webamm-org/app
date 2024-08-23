module Plans
  module WebammExporters
    module DatabaseSchema
      class Column
        def self.to_webamm(column)
          base_def = {
            'name' => column.name,
            'null' => column.can_be_null,
            'default' => column.default_value,
            'type' => column.field_type
          }

          return base_def unless column.field_type == 'enum_column'

          base_def['values'] = column.options.fetch('enums', [])

          base_def
        end
      end
    end
  end
end
