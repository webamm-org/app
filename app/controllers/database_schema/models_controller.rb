module DatabaseSchema
  class ModelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan

    def index
      @models = @plan.db_models.includes(:columns).order(:name)
    end

    def new
      @model = @plan.db_models.new
    end

    def create
      @model = @plan.db_models.new(model_params)

      if @model.save
        redirect_to plan_database_schema_models_path(@plan, expand: @model.id), notice: 'Model was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def model_params
      params.require(:database_schema_model).permit(:name)
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end
  end
end
