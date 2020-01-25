# frozen_string_literal: true

class JwtParams
  SECRET = ENV.fetch('HMAC_SECRET')
  ATTRIBUTES = %i[score touchpoint respondent_class respondent_id object_class object_id].freeze

  attr_reader *ATTRIBUTES
  attr_reader :payload

  def initialize(token)
    @payload = JWT.decode(token, SECRET, true).first.symbolize_keys

    ATTRIBUTES.each do |attribute|
      self.instance_variable_set("@#{attribute}", @payload.fetch(attribute))
    end

    @valid = true
  rescue JWT::VerificationError, KeyError
    @valid = false
  end

  def valid?
    @valid
  end
end
