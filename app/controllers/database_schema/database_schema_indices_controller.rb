module DatabaseSchema
  class DatabaseSchemaIndicesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model
    before_action :set_index, only: [:destroy]

    def new
      @index = @model.indices.new
      @columns = @model.columns.order(:name)
    end

    def create
      @index = @model.indices.new(index_params)
      @columns = @model.columns.order(:name)

      if @index.save
        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Index was successfully created.'
      else
        render :new
      end
    end

    def destroy
      @index.destroy

      redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Index was successfully destroyed.'
    end

    private

    def index_params
      params.require(:database_schema_index).permit(:is_unique, column_ids: [])
    end

    def set_index
      @index = @model.indices.find(params[:id])
    end

    def set_model
      @model = @plan.db_models.find(params[:database_schema_model_id])
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end
  end
end
