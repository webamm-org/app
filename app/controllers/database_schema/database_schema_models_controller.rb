module DatabaseSchema
  class DatabaseSchemaModelsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan

    def index
      @models = @plan.db_models.includes(:columns, :authentication, indices: :columns, associations: :destination_database_schema_model).order(:name)
    end

    def new
      @model = @plan.db_models.new
    end

    def create
      @model = @plan.db_models.new(model_params)

      if @model.save
        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Model was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @model = @plan.db_models.find(params[:id])
    end

    def update
      @model = @plan.db_models.find(params[:id])

      if @model.update(model_params)
        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Model was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @model = @plan.db_models.find(params[:id])
      
      ActiveRecord::Base.transaction do
        if @model.options.fetch('habtm', false)
          source_model = @model.plan.db_models.find(@model.options.fetch('source_model_id'))
          destination_model = @model.plan.db_models.find(@model.options.fetch('destination_model_id'))
  
          DatabaseSchema::Association.where(
            source_database_schema_model_id: source_model.id,
            destination_database_schema_model_id: destination_model.id,
            connection_type: 'has_many_and_belongs_to_many_assoc').each do |assoc|
              assoc.destroy!
            end
  
          DatabaseSchema::Association.where(
            source_database_schema_model_id: destination_model.id,
            destination_database_schema_model_id: source_model.id,
            connection_type: 'has_many_and_belongs_to_many_assoc').each do |assoc|
              assoc.destroy!
            end
        end
  
        @model.destroy!
      end

      redirect_to plan_database_schema_database_schema_models_path(@plan), notice: 'Model was successfully deleted.'
    end

    private

    def model_params
      params.require(:database_schema_model).permit(:name, options: [:use_uuid]).tap do |whitelisted|
        whitelisted[:options] = {} if whitelisted[:options].blank?
      end
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end
  end
end
