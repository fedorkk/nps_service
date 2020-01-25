require 'rails_helper'

describe NetPromoterScore, type: :model do
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
  let(:nps) { described_class.new(attributes) }

  it 'works' do
    expect(nps.valid?).to eq(true)
  end

  describe 'validations' do
    context 'nil score' do
      let(:attributes) { super().merge(score: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'not numeric score' do
      let(:attributes) { super().merge(score: 'test') }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'score less than 0' do
      let(:attributes) { super().merge(score: -1) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'score greater than 10' do
      let(:attributes) { super().merge(score: 11) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'nil touchpoint' do
      let(:attributes) { super().merge(touchpoint: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'nil respondent_class' do
      let(:attributes) { super().merge(respondent_class: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'nil respondent_id' do
      let(:attributes) { super().merge(respondent_id: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'not numeric respondent_id' do
      let(:attributes) { super().merge(respondent_id: 'test') }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'nil object_class' do
      let(:attributes) { super().merge(object_class: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'nil object_id' do
      let(:attributes) { super().merge(object_id: nil) }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'not numeric object_id' do
      let(:attributes) { super().merge(object_id: 'test') }

      it { expect(nps.valid?).to eq(false) }
    end

    context 'duplicated nps' do
      it 'is invalid' do
        described_class.create(attributes)

        expect(nps.valid?).to eq(false)
      end
    end
  end
end
