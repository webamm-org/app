module DatabaseSchema
  class ColumnsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model

    def new
      @column = @model.columns.new
    end

    def create
      @column = @model.columns.new(column_params)

      if @column.save
        redirect_to plan_database_schema_models_path(@plan, expand: @model.id), notice: 'Column was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def column_params
      params.require(:database_schema_column).permit(:name, :field_type)
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end

    def set_model
      @model = @plan.db_models.find(params[:model_id])
    end
  end
end
