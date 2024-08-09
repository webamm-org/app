module DatabaseSchema
  class DatabaseSchemaAssociationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model
    before_action :set_association, only: [:destroy]

    def new
      @association = @model.associations.new
      @models = @plan.db_models.where.not(id: @model.id)
    end

    def create
      @association = @model.associations.new(association_params)
      @models = @plan.db_models.where.not(id: @model.id)

      if @association.valid?
        ActiveRecord::Base.transaction do
          @association.save!
          ::DatabaseSchemaAssociations::CreationCallback.call(@association)
        end

        redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Association was successfully created.'
      else
        render :new
      end
    end

    def destroy
      ActiveRecord::Base.transaction do
        ::DatabaseSchemaAssociations::DestroyCallback.call(@association)
        @association.destroy!
      end

      redirect_to plan_database_schema_database_schema_models_path(@plan, expand: @model.id), notice: 'Association was successfully destroyed.'
    end

    private

    def association_params
      params.require(:database_schema_association).permit(:destination_database_schema_model_id, :connection_type, connection_options: [:optional])
    end

    def set_association
      @association = @model.associations.find(params[:id])
    end

    def set_model
      @model = @plan.db_models.find(params[:database_schema_model_id])
    end

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end
  end
end
