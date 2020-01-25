# frozen_string_literal: true

class JwtParams
  class InvalidToken < StandardError; end

  SECRET = ENV.fetch('HMAC_SECRET')
  ATTRIBUTES = %i[score touchpoint respondent_class respondent_id object_class object_id].freeze

  attr_reader :payload, :errors

  def initialize(token)
    @payload = JWT.decode(token, SECRET, true).first.symbolize_keys
    @valid = true

    ATTRIBUTES.each do |attribute|
      add_error(attribute) unless @payload.fetch(attribute, nil)
    end
  rescue JWT::VerificationError
    raise InvalidToken
  end

  def valid?
    @valid
  end

  private

  def add_error(attribute)
    @valid = false
    @errors ||= {}
    @errors[attribute] = ['is required']
  end
end
