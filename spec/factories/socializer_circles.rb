# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_circle, class: Socializer::Circle do
    sequence(:display_name) { |n| "Friends no#{n}" }
    content 'This is some content'
    association :activity_author, factory: :socializer_activity_object_person

    trait :with_ties do
      transient do
        number_of_ties 1
      end

      after :create do |circle, evaluator|
        create_list :socializer_tie, evaluator.number_of_ties, circle: circle
      end
    end
  end
end
