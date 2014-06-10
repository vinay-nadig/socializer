require 'rails_helper'

module Socializer
  RSpec.describe Authentication, type: :model do
    let(:authentication) { build(:socializer_authentication) }

    it 'has a valid factory' do
      expect(authentication).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:provider) }
      it { is_expected.to allow_mass_assignment_of(:uid) }
      it { is_expected.to allow_mass_assignment_of(:image_url) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:person) }
    end

    context 'when last authentication for a person' do
      let(:last_authentication) { create(:socializer_authentication) }

      it { expect(last_authentication.person.authentications.count).to eq(1) }

      it 'cannot be deleted' do
        expect { last_authentication.destroy }.to raise_error
      end
    end
  end
end
