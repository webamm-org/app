module DatabaseSchema
  class ModelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan

    def index
      @models = @plan.db_models.order(:name)
    end

    private

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end
  end
end
