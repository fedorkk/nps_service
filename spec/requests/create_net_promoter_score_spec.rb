require 'rails_helper'

describe 'create NetPromoterScore', type: :request do
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
  let(:params) { { token: JWT.encode(attributes, secret) } }
  let(:request) { post '/api/net_promoter_scores', params: params }

  it 'returns 200 status' do
    request
    expect(response).to have_http_status(:ok)
  end

  it 'creates new NetPromoterScore' do
    expect { request }.to change { NetPromoterScore.count }.by(1)
  end

  context 'when the same NPS already exists' do
    let!(:existed_nps) { NetPromoterScore.create(attributes.merge(score: 5)) }

    it 'returns 200 status' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'does not create new NetPromoterScore' do
      expect { request }.not_to change { NetPromoterScore.count }
    end

    it 'updates existed NetPromoterScore' do
      expect { request }.to change { NetPromoterScore.last.score }.from(5).to(1)
    end
  end

  context 'with invalid token' do
    let(:secret) { 'test_bad_secret' }

    it 'returns 401 code' do
      request
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'without full data in payload' do
    let(:attributes) { super().reject { |k| k == :score } }

    it 'returns 401 code' do
      request
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with invalid data in payload' do
    let(:attributes) { super().merge(score: 'test') }

    it 'returns 422 code' do
      request
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns errors json' do
      request

      expect(JSON.parse(response.body)['errors']['score'].first).to eq('is not a number')
    end
  end
end
