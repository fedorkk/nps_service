# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from JwtParams::InvalidToken, with: :unauthorized

    private

    def bad_request
      head :bad_request
    end

    def unauthorized
      head :unauthorized
    end
  end
end
