#
# Namespace for the Socializer engine
#
module Socializer
  class Authentication < ActiveRecord::Base
    attr_accessible :provider, :uid, :image_url

    # Relationships
    belongs_to :person

    # Named Scopes
    scope :by_provider, -> provider { where(provider: provider.downcase) }
    scope :by_not_provider, -> provider { where.not(provider: provider.downcase) }

    # Callbacks
    before_destroy :make_sure_its_not_the_last_one

    private

    def make_sure_its_not_the_last_one
      return unless person.authentications.count == 1
      # FIXME: authentication - This is not a good user experience.
      #       If the user clicks 'unbind' on their last authentication they will get an error.
      #       A flash notice should be set and the user should be able to continue on.
      # TODO: Add translation
      fail 'Cannot delete the last authentication available.'
    end
  end
end
