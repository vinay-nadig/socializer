#
# Namespace for the Socializer engine
#
module Socializer
  class Notification < ActiveRecord::Base
    attr_accessible :read

    # Relationships
    belongs_to :activity, inverse_of: :notifications
    belongs_to :activity_object, inverse_of: :notifications # Person, Group, ...

    # Validations
    validates :activity_id, presence: true
    validates :activity_object_id, presence: true

    # Named Scopes
    scope :newest_first, -> { order(created_at: :desc) }

    # Callbacks
    # Increment the number of unread notifications
    after_save { activity_object.increment_unread_notifications_count }

    # Class methods - Public

    # Create notifications for the given activity
    #
    # @param activity [Socializer::Activity] the activity to create the notifications for
    #
    # @return [Array] an [Array] of [Socializer::Notification] objects
    def self.create_for_activity(activity)
      # Get all ties related to the audience of the activity
      potential_contact_id = get_potential_contact_id(activity.id)

      potential_contact_id.each do |tie|
        next unless person_in_circle?(tie.contact_id, activity.activitable_actor.id)
        # If the contact has the author of the activity in one of his circle.
        create_notification(activity, tie.contact_id)
      end
    end

    # Instance methods

    # Marks the notification as read
    #
    # @return [boolean]
    def read!
      update!(read: true)
    end

    # Is the notification unread?
    #
    # @return [boolean]
    def unread?
      !read
    end

    # Class methods - Private

    # Create a notification for the given activity and contact
    #
    # @param activity [Socializer::Activity]
    # @param contact_id [Socializer::Person]
    #
    # @return [Socializer::Notification]
    def self.create_notification(activity, contact_id)
      object = Notification.new do |notification|
        notification.activity = activity
        notification.activity_object = ActivityObject.find_by(id: contact_id)
      end

      object.save!
    end
    private_class_method :create_notification

    # FIXME: Move to Tie or Activity
    def self.get_potential_contact_id(activity_id)
      # Activity -> Audience -> ActivityObject -> Circle -> Tie -> contact_id
      Tie.select(:contact_id)
         .joins(circle: { activity_object: :audiences })
         .merge(Audience.by_activity_id(activity_id))
         .flatten.uniq
    end
    private_class_method :get_potential_contact_id

    # FIXME: Move to ActivityObject or Circle
    def self.person_in_circle?(parent_contact_id, child_contact_id)
      # ActivityObject.id = parent_contact_id
      # ActivityObject -> Circle -> Tie -> contact_id = child_contact_id
      ActivityObject.select(:id)
                    .joins(circles: :ties)
                    .by_id(parent_contact_id)
                    .merge(Tie.by_contact_id(child_contact_id))
                    .present?
    end
    private_class_method :person_in_circle?
  end
end
