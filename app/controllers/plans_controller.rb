# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]

  before_action :authenticate_user!, only: %i[index show update edit create new destroy]

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
    @users = User.all
  end

  def create
    @plan = Plan.new(plan_params)

    @users = User.all

    if @plan.save
      redirect_to @plan, notice: 'Plan was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
    @users = User.all
  end

  def update
    @users = User.all

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
    params.require(:plan).permit(:name, :user_id)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end
end
