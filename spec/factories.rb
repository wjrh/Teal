# Factories are the way we're using to mock data for tests.
# Here, we're defining the barebones needed to create an object
# Read up on FactoryGirl for more info

FactoryGirl.define do

  # create creator factory
  factory :creator do
    lafayetteid "jamesd"
    email "jamesd@lafayette.edu"
    name "DEEJAY coconut"
    real_name "James Davadasa"
    description "I'm a bad DJ"
  end


  # create program factory
  factory :program do
    title "Mango Radio Program"
    image "http://lorempixel.com/400/200/"
    description  "this is a description for our program"
    creators {[create(:creator)]}
  end




  # create episode factory
  factory :episode do
  	title "wonderful episode"
  	description "wonderful episode here"
  	program # all episodes need a program 

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
