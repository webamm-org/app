module DatabaseSchema
  class DatabaseSchemaColumnsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model

    def new
      @column = @model.columns.new
    end

    def create
      @column = @model.columns.new(column_params)

      if @column.save
        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Column was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @column = @model.columns.find(params[:id])
    end

    def update
      @column = @model.columns.find(params[:id])

      if @column.update(column_params)
        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Column was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @column = @model.columns.find(params[:id])
      @column.destroy
      redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Column was successfully removed.'
    end
    
    private

    def column_params
      params.require(:database_schema_column).permit(:name, :field_type, :can_be_null, :default_value)
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end

    def set_model
      @model = @plan.db_models.find(params[:database_schema_model_id])
    end
  end
end
