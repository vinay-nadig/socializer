#
# Namespace for the Socializer engine
#
module Socializer
  module Activities
    class AudiencesController < ApplicationController
      before_action :authenticate_user!

      def index
        activity    = Activity.find_by(id: params[:id])
        @object_ids = ActivityAudienceList.new(activity: activity).perform

        respond_to do |format|
          format.html { render layout: false if request.xhr? }
        end
      end
    end
  end
end
