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

    # factory for creators with programs
    factory :creator_with_programs do
      #associate programs with creators
      after(:build) do |creator, evaluator|
        2.times do
          creator.programs << build(:program)
        end
      end
    end
  end


  # create program factory
  factory :program do
    title "Mango Radio Program"
    description  "this is a description for our program"

    # all programs need creators. This creates two more
    after(:build) do |program, evaluator|
      2.times do
        program.creators << build(:creator)
      end
    end
  end




  # create episode factory
  factory :episode do
  	name "wonderful episode"
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
