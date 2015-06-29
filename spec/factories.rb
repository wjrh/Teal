# Factories are the way we're using to mock data for tests.
# Here, we're defining the barebones needed to create an object
# Read up on FactoryGirl for more info

FactoryGirl.define do

  # create creator factory
  factory :creator do
    net_id "jamesd"
    email "jamesd@lafayette.edu"
    creator_name "DEEJAY coconut"
    real_name "James Davadasa"
    description "I'm a bad DJ"

    # factory for creators with shows
    factory :creator_with_shows do
      #associate shows with creators
      after(:build) do |creator, evaluator|
        2.times do
          creator.shows << build(:show)
        end
      end
    end
  end


  # create show factory
  factory :show do
    title "Mango Radio Show"
    description  "this is a description for our show"

    # all shows need creators. This creates two more
    after(:build) do |show, evaluator|
      2.times do
        show.creators << build(:creator)
      end
    end
  end




  # create episode factory
  factory :episode do
  	name "wonderful episode"
  	description "wonderful episode here"
  	show # all episodes need a show 

    # all episodes need creators
    after(:build) do |episode, evaluator|
      2.times do
        episode.creators << build(:creator)
      end
    end
  end



  # create songs factory
  factory :song do
  	artist "James Dunn"
  	title "A Beaut Song"
  	ISRC "3432423234"
  end
end
