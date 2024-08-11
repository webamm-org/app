module Authentications
  class CreationCallback
    def self.call(plan:, authentication:)
      ActiveRecord::Base.transaction do
        model = plan.db_models.find_or_create_by!(name: authentication.name)
        authentication.update!(model: model)
      end
    end
  end
end
