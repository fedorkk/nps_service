# frozen_string_literal: true

module Api
  class NetPromoterScoresController < BaseController
    def create
      jwt_params = JwtParams.new(params[:token])

      if jwt_params.valid?
        payload = jwt_params.payload
        score = payload.delete(:score)

        nps = NetPromoterScore.find_or_initialize_by(payload)
        nps.score = score

        if nps.save
          head :ok
        else
          render json: { errors: nps.errors }, status: :unprocessable_entity
        end
      else
        render json: { errors: jwt_params.errors }, status: :unprocessable_entity
      end
    end

    def index
      scope = NetPromoterScore.where(touchpoint: index_params)
      scope = scope.where(respondent_class: params[:respondent_class]) if params[:respondent_class].present?
      scope = scope.where(object_class: params[:object_class]) if params[:object_class].present?

      render json: { net_promoter_scores: scope }
    end

    private

    def index_params
      params.require(:touchpoint)
    end
  end
end
