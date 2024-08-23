# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy generate_app authorization_options]
  before_action :authenticate_user!

  layout false, only: :authorization_options

  def index
    @plans = Plan.all
  end

  def new
    @plan = current_user.plans.new
  end

  def create
    @plan = current_user.plans.new(plan_params)

    if @plan.save
      redirect_to plan_database_schema_database_schema_models_path(@plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: 'Plan was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ::Plan.transaction do
      ::DatabaseSchema::Association.where(source_database_schema_model_id: @plan.db_models.pluck(:id)).find_each do |assoc|
        assoc.destroy!
      end

      ::DatabaseSchema::Association.where(destination_database_schema_model_id: @plan.db_models.pluck(:id)).find_each do |assoc|
        assoc.destroy!
      end

      @plan.destroy!
    end

    redirect_to :plans, notice: 'Plan was successfully destroyed.'
  end

  def authorization_options
    model_ids_raw = params.fetch(:model_ids, '')
    model_ids = model_ids_raw.split(',')
    
    @options_for_select = ::Plans::Authorization::GetOptions.new(plan: @plan, model_ids: model_ids).call
    @action_name = params.fetch(:action_name)
    @selected_options = params.fetch(:selected_options, '').split(',')
  end

  def generate_app; end

  private

  def plan_params
    params.require(:plan).permit(:name, :usd_rate)
  end

  def set_plan
    @plan = current_user.plans.find(params[:id])
  end
end
