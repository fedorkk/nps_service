# frozen_string_literal: true

class JwtParams
  SECRET = ENV.fetch('HMAC_SECRET')
  ATTRIBUTES = %i[score touchpoint respondent_class respondent_id object_class object_id].freeze

  attr_reader :payload

  def initialize(token)
    @payload = JWT.decode(token, SECRET, true).first.symbolize_keys

    # The fetch method raises the KeyError exceprion if the key doesn't exist.
    # It's a simples check that all necessary fields are existed in the payload, which means that it's valid for our case.
    # In a more complex situation we can use anoter instrument like dry-struckt
    ATTRIBUTES.each do |attribute|
      @payload.fetch(attribute)
    end

    @valid = true
  rescue JWT::VerificationError, KeyError
    @valid = false
  end

  def valid?
    @valid
  end
end
