# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :bad_request

    private

    def bad_request
      head :bad_request
    end
  end
end
