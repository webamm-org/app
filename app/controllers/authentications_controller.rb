class AuthenticationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def index
    @authentications = @plan.authentications.includes(:model).order(created_at: :desc)
  end

  def new
    @authentication = @plan.authentications.build
  end

  def create
    @authentication = @plan.authentications.build(authentication_params)

    if @authentication.valid?
      ::Authentications::CreationCallback.call(plan: @plan, authentication: @authentication)

      redirect_to plan_authentications_path(@plan), notice: 'Authentication was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @authentication = @plan.authentications.find(params[:id])
  end

  def update
    @authentication = @plan.authentications.find(params[:id])

    if @authentication.update(authentication_params)
      redirect_to plan_authentications_path(@plan), notice: 'Authentication was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @authentication = @plan.authentications.find(params[:id])

    Authentication.transaction do
      if @authentication.model.columns.none?
        @authentication.model.destroy!
      else
        @authentication.destroy!
      end
    end

    redirect_to plan_authentications_path(@plan), notice: 'Authentication was successfully destroyed.'
  end

  private

  def set_plan
    @plan = current_user.plans.find(params[:plan_id])
  end

  def authentication_params
    params.require(:authentication).permit(:name, options: [:online_indication, :invitations, :two_factor_authentication, :allow_sign_up]).tap do |whitelisted|
      whitelisted[:options] = {} if whitelisted[:options].blank?
    end
  end
end
