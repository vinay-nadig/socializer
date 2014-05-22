require 'spec_helper'

module Socializer
  describe PersonLink, type: :model do
    let(:person_link) { build(:socializer_person_link) }

    it 'has a valid factory' do
      expect(person_link).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_link).to allow_mass_assignment_of(:label) }
      it { expect(person_link).to allow_mass_assignment_of(:url) }
    end

    context 'relationships' do
      it { expect(person_link).to belong_to(:person) }
    end

    context 'validations' do
      it { expect(person_link).to validate_presence_of(:label) }
      it { expect(person_link).to validate_presence_of(:url) }
    end

  end
end
