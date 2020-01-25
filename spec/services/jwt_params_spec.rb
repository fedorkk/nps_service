require 'rails_helper'

describe JwtParams do
  let(:attributes) do
    {
      score: 1,
      touchpoint: 'feedback',
      respondent_class: 'seller',
      respondent_id: 1,
      object_class: 'realtor',
      object_id: 1
    }
  end
  let(:secret) { ENV.fetch('HMAC_SECRET') }
  let(:token) { JWT.encode(attributes, secret) }
  let(:jwt_params) { described_class.new(token) }

  it { expect(jwt_params.valid?).to eq(true) }
  it { expect(jwt_params.payload).to eq(attributes) }

  context 'invalid token' do
    let(:secret) { 'test_bad_secret' }

    it { expect { jwt_params }.to raise_error(JwtParams::InvalidToken) }
  end

  describe 'invalid data in payload' do
    context 'score does not exist' do
      let(:attributes) { super().reject { |k| k == :score } }

      it { expect(jwt_params.valid?).to eq(false) }
    end

    context 'touchpoint does not exist' do
      let(:attributes) { super().reject { |k| k == :touchpoint } }

      it { expect(jwt_params.valid?).to eq(false) }
    end

    context 'respondent_class does not exist' do
      let(:attributes) { super().reject { |k| k == :respondent_class } }

      it { expect(jwt_params.valid?).to eq(false) }
    end

    context 'respondent_id does not exist' do
      let(:attributes) { super().reject { |k| k == :respondent_id } }

      it { expect(jwt_params.valid?).to eq(false) }
    end

    context 'object_class does not exist' do
      let(:attributes) { super().reject { |k| k == :object_class } }

      it { expect(jwt_params.valid?).to eq(false) }
    end

    context 'object_id does not exist' do
      let(:attributes) { super().reject { |k| k == :object_id } }

      it { expect(jwt_params.valid?).to eq(false) }
    end
  end
end
