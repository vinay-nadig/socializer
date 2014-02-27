require 'spec_helper'

module Socializer
  describe ApplicationDecorator do
    context 'created_at_time_ago' do
      let(:activity) { create(:socializer_activity) }
      let(:decorated_activity) { ActivityDecorator.new(activity) }
      let(:created_at) { activity.created_at.to_time.utc }
      let(:updated_at) { activity.updated_at.to_time.utc }

      it { expect(decorated_activity).to respond_to(:created_at_time_ago) }

      context 'when created_at and updated_at are equal' do
        let(:time_tag) do
          %Q(<time data-time-ago="moment.js" datetime="#{created_at.iso8601}" title="#{created_at.to_s(:short)}">#{created_at.strftime('%B %e, %Y %l:%M%P')}</time>)
        end

        it { expect(decorated_activity.created_at_time_ago).to eq(time_tag) }
      end

      context 'when created_at and updated_at are different' do
        before do
          decorated_activity.created_at = Time.now - 1.hour
          decorated_activity.save!
        end

        let(:time_tag) do
          %Q(<time data-time-ago="moment.js" datetime="#{created_at.iso8601}" title="#{created_at.to_s(:short)}&#10;(edited #{updated_at.to_s(:short)})">#{created_at.strftime('%B %e, %Y %l:%M%P')}</time>)
        end

        it { expect(decorated_activity.created_at_time_ago).to eq(time_tag) }
      end
    end
  end
end