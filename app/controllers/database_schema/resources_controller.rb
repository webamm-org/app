module DatabaseSchema
  class ResourcesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_plan
    before_action :set_model

    def new
      @resource = @model.resources.new
      @models = @plan.db_models.includes(:authentication)
      @columns = @model.columns.order(:name)
    end

    def create
      @resource = @model.resources.new(resource_params)
      @resource.plan = @plan

      if @resource.save
        redirect_to plan_resources_path(@plan), notice: "Resource created successfully"
      else
        @models = @plan.db_models.includes(:authentication)
        @columns = @model.columns.order(:name)

        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @resource = @model.resources.find(params[:id])
      @resource.destroy!

      redirect_to plan_resources_path(@plan), notice: "Resource deleted successfully"
    end

    def edit
      @resource = @model.resources.find(params[:id])
      @models = @plan.db_models.includes(:authentication)
      @columns = @model.columns.order(:name)
    end

    def update
      @resource = @model.resources.find(params[:id])

      if @resource.update(resource_params)
        redirect_to plan_resources_path(@plan), notice: "Resource updated successfully"
      else
        @models = @plan.db_models.includes(:authentication)
        @columns = @model.columns.order(:name)

        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_plan
      @plan = current_user.plans.find(params[:plan_id])
    end

    def set_model
      @model = @plan.db_models.find(params[:database_schema_model_id])
    end

    def resource_params
      params.require(:resource).permit(
        index_options: [:include, { authentication: [] }, { attributes: [] }, { authorization: [] }],
        show_options: [:include, { authentication: [] }, { attributes: [] }, { authorization: [] }],
        create_options: [:include, { authentication: [] }, { attributes: [] }, { authorization: [] }],
        update_options: [:include, { authentication: [] }, { attributes: [] }, { authorization: [] }],
        destroy_options: [:include, { authentication: [] }, { attributes: [] }, { authorization: [] }],
      )
    end
  end
end
