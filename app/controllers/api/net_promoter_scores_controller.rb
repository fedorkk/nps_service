# frozen_string_literal: true

module Api
  class NetPromoterScoresController < ApplicationController
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
        head :unauthorized
      end
    end
  end
end
