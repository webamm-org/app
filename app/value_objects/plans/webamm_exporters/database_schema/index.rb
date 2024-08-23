module Plans
  module WebammExporters
    module DatabaseSchema
      class Index
        def self.to_webamm(index)
          column_names = index.columns.map(&:name)

          {
            'unique' => index.is_unique,
            'columns' => column_names,
            'name' => "#{column_names.join('_')}_idx"
          }
        end
      end
    end
  end
end
