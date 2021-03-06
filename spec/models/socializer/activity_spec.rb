require 'rails_helper'

module Socializer
  RSpec.describe Activity, type: :model do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:verb) }
      it { is_expected.to allow_mass_assignment_of(:circles) }
      it { is_expected.to allow_mass_assignment_of(:actor_id) }
      it { is_expected.to allow_mass_assignment_of(:activity_object_id) }
      it { is_expected.to allow_mass_assignment_of(:target_id) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:parent) }
      it { is_expected.to belong_to(:activitable_actor) }
      it { is_expected.to belong_to(:activitable_object) }
      it { is_expected.to belong_to(:activitable_target) }
      it { is_expected.to belong_to(:verb) }
      it { is_expected.to have_one(:activity_field) }
      it { is_expected.to have_many(:audiences).inverse_of(:activity) }
      it { is_expected.to have_many(:activity_objects) }
      it { is_expected.to have_many(:children) }
      it { is_expected.to have_many(:notifications).inverse_of(:activity) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:activitable_actor) }
      it { is_expected.to validate_presence_of(:activitable_object) }
      it { is_expected.to validate_presence_of(:verb) }
    end

    context 'scopes' do
      context 'newest_first' do
        let(:sql) { Activity.newest_first.to_sql }

        it { expect(sql).to include('ORDER BY "socializer_activities"."created_at" DESC') }
      end

      context 'by_id' do
        let(:sql) { Activity.by_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_activities"."id" = 1') }
      end

      context 'by_activity_object_id' do
        let(:sql) { Activity.by_activity_object_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_activities"."activity_object_id" = 1') }
      end

      context 'by_actor_id' do
        let(:sql) { Activity.by_actor_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_activities"."actor_id" = 1') }
      end

      context 'by_target_id' do
        let(:sql) { Activity.by_target_id(1).to_sql }

        it { expect(sql).to include('WHERE "socializer_activities"."target_id" = 1') }
      end
    end

    it { is_expected.to delegate_method(:activity_field_content).to(:activity_field).as(:content) }
    it { is_expected.to delegate_method(:verb_display_name).to(:verb).as(:display_name) }

    context '#comments' do
      it { expect(activity.comments?).to eq(false) }

      context 'to be true' do
        let(:activity) { create(:socializer_activity) }
        let(:scope) { Audience.privacy.find_value(:public) }
        let(:comment_attributes) { { content: 'Comment', activity_target_id: activity.id, activity_verb: 'add', scope: scope } }
        let(:actor) { activity.actor }

        before :each do
          actor.comments.create!(comment_attributes)
        end

        it { expect(activity.comments?).to eq(true) }
      end
    end

    # TODO: Test return values
    it { expect(activity.actor).to be_kind_of(Socializer::Person) }
    it { expect(activity.object).to be_kind_of(Socializer::Note) }
    it { expect(activity.target).to be_kind_of(Socializer::Group) }

    context '.stream' do
      let(:activity_object_person) { build(:socializer_activity_object_person) }
      let(:activity_object_group) { build(:socializer_activity_object_group) }
      let(:person) { activity_object_person.activitable }
      let(:group) { activity_object_group.activitable }

      # TODO: Test return values
      it { expect { Activity.stream }.to raise_error(ArgumentError) }
      it { expect(Activity.stream(viewer_id: person.id)).to be_kind_of(ActiveRecord::Relation) }
      it { expect(Activity.activity_stream(actor_uid: person.id, viewer_id: person.id)).to be_kind_of(ActiveRecord::Relation) }
      it { expect(Activity.circle_stream(actor_uid: person.id, viewer_id: person.id)).to be_kind_of(ActiveRecord::Relation) }
      it { expect(Activity.group_stream(actor_uid: group.id, viewer_id: person.id)).to be_kind_of(ActiveRecord::Relation) }
      it { expect(Activity.person_stream(actor_uid: person.id, viewer_id: person.id)).to be_kind_of(ActiveRecord::Relation) }
    end
  end
end
