module DatabaseSchema
  class ResourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model

    def new
      @resource = @model.resources.new
    end

    private

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end

    def set_model
      @model = @plan.db_models.find(params[:database_schema_model_id])
    end
  end
end
