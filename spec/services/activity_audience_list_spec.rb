require 'rails_helper'

module Socializer
  RSpec.describe ActivityAudienceList, type: :service do
    describe 'when the activity argument is nil' do
      context '.new should raise an ArgumentError' do
        let(:audience_list) { ActivityAudienceList.new(activity: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end

      context '.perform should raise an ArgumentError' do
        let(:audience_list) { ActivityAudienceList.perform(activity: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    describe 'when the activity argument is the wrong type' do
      let(:audience_list) { ActivityAudienceList.new(activity: Person.new) }
      it { expect { audience_list }.to raise_error(ArgumentError) }
    end

    describe '.perform' do
      context 'without an audience' do
        let(:activity) { create(:socializer_activity) }
        let(:audience_list) { ActivityAudienceList.new(activity: activity).perform }

        it { expect(audience_list).to be_kind_of(Array) }
        it { expect(audience_list.size).to eq(1) }
        it { expect(audience_list.first).to start_with('name') }
      end

      context 'with an audience' do
        let(:person) { create(:socializer_person) }
        let(:note) { person.activity_object.notes.create!(content: 'Test note', object_ids: ['public'], activity_verb: 'post') }
        let(:activity) { Activity.find_by(activity_object_id: note.activity_object.id) }

        context 'public' do
          let(:audience_list) { ActivityAudienceList.new(activity: activity).perform }

          it { expect(audience_list.size).to eq(1) }
          it { expect(audience_list.first).to eq(I18n.t('socializer.activities.audiences.index.tooltip.public')) }
        end

        context 'that is circles' do
          before :each do
            AddDefaultCircles.perform(person: person)
          end

          let(:note) { person.activity_object.notes.create!(content: 'Test note', object_ids: ['circles'], activity_verb: 'post') }
          let(:activity) { Activity.find_by(activity_object_id: note.activity_object.id) }
          let(:audience_list) { ActivityAudienceList.new(activity: activity).perform }

          it { expect(audience_list.size).to eq(1) }
          it { expect(audience_list.first).to start_with('name') }
        end

        context 'that is limited' do
          before :each do
            AddDefaultCircles.perform(person: person)
          end

          let(:family) { Circle.find_by(author_id: person.id, display_name: 'Family') }
          let(:note) { person.activity_object.notes.create!(content: 'Test note', object_ids: [family.id], activity_verb: 'post') }
          let(:activity) { Activity.find_by(activity_object_id: note.activity_object.id) }
          let(:audience_list) { ActivityAudienceList.new(activity: activity).perform }

          it { expect(audience_list.size).to eq(1) }
          it { expect(audience_list.first).to start_with('name') }
        end
      end
    end
  end
end
