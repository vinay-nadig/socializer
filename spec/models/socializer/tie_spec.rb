require 'rails_helper'

module Socializer
  RSpec.describe Tie, type: :model do
    let(:contact) { create(:socializer_person) }
    let(:tie) { build(:socializer_tie, contact_id: contact.id) }

    it 'has a valid factory' do
      expect(tie).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:contact_id) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:circle).inverse_of(:ties) }
      it { is_expected.to belong_to(:activity_contact).class_name('ActivityObject').with_foreign_key('contact_id').inverse_of(:ties) }
      it { is_expected.to have_one(:contact).through(:activity_contact).source(:activitable) }
    end

    context 'scopes' do
      context 'by_circle_id' do
        let(:sql) { Tie.by_circle_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_ties"."circle_id" = 1') }
      end

      context 'by_contact_id' do
        let(:sql) { Tie.by_contact_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_ties"."contact_id" = 1') }
        it { expect(tie.contact_id).to eq(contact.id) }

        context 'nil' do
          let(:tie) { build(:socializer_tie, contact_id: nil) }
          it { expect(tie.contact_id).to eq(nil) }
        end
      end
    end

    # TODO: Test return values
    it { expect(tie.contact).to be_kind_of(Socializer::Person) }
  end
end
