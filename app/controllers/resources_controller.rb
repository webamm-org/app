class ResourcesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def index
    @resources = @plan.resources
    @models = @plan.db_models.order(:name)
  end

  def create
    model_id = params[:database_schema_model_id]

    if model_id.blank?
      redirect_to plan_resources_path(@plan), alert: 'Please select a model'
    else
      model = @plan.db_models.find(model_id)
      redirect_to new_plan_database_schema_database_schema_model_resource_path(@plan, model)
    end
  end

  private

  def set_plan
    @plan = current_user.plans.find(params[:plan_id])
  end
end
