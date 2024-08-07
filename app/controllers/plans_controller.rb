# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    @plans = Plan.all
  end

  def new
    @plan = current_user.plans.new
  end

  def create
    @plan = current_user.plans.new(plan_params)

    if @plan.save
      redirect_to @plan, notice: 'Plan was successfully created.'
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
    @plan.destroy!

    redirect_to :plans, notice: 'Plan was successfully destroyed.'
  end

  private

  def plan_params
    params.require(:plan).permit(:name)
  end

  def set_plan
    @plan = current_user.plans.find(params[:id])
  end
end
