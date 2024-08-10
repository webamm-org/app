module Api
  module V1
    class PlansController < ApplicationController
      def show
        plan = Plan.find_by(id: params[:id])

        if plan.present?
          files = ::WamlToRails.generate(plan.to_waml)

          render json: files, status: :ok
        else
          render json: { error: 'Plan not found' }, status: :not_found
        end
      end
    end
  end
end
