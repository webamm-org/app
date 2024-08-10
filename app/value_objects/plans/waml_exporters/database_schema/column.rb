module Plans
  module WamlExporters
    module DatabaseSchema
      class Column
        def self.to_waml(column)
          {
            'name' => column.name,
            'null' => column.can_be_null,
            'default' => column.default_value,
            'type' => column.field_type
          }
        end
      end
    end
  end
end
