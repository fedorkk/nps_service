require 'rails_helper'

describe 'index NetPromoterScore', type: :request do
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
  let!(:nps) { NetPromoterScore.create(attributes) }
  let!(:nps_2) { NetPromoterScore.create(attributes.merge(respondent_class: 'another_respondent')) }
  let!(:nps_3) { NetPromoterScore.create(attributes.merge(object_class: 'another_object')) }
  let(:params) { { touchpoint: 'feedback' } }
  let(:request) { get '/api/net_promoter_scores', params: params }
  let(:body) { JSON.parse(response.body)['net_promoter_scores'] }

  it 'returns 200 status' do
    request
    expect(response).to have_http_status(:ok)
  end

  it 'returns the list of NetPromoterScores' do
    request

    expect(body.size).to eq(3)
    expect(body.first['touchpoint']).to eq('feedback')
  end

  context 'with specified respondent_class' do
    let(:params) { super().merge(respondent_class: 'another_respondent') }

    it 'returns 200 status' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'returns the list of NetPromoterScores only with specified respondent_class' do
      request

      expect(body.size).to eq(1)
      expect(body.first['respondent_class']).to eq('another_respondent')
    end
  end

  context 'with specified object_class' do
    let(:params) { super().merge(object_class: 'another_object') }

    it 'returns 200 status' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'returns the list of NetPromoterScores only with specified object_class' do
      request

      expect(body.size).to eq(1)
      expect(body.first['object_class']).to eq('another_object')
    end
  end

  context 'without required params' do
    let(:params) { {} }

    it 'returns 400 status' do
      request
      expect(response).to have_http_status(:bad_request)
    end
  end
end
