# Factories are the way we're using to mock data for tests.
# Here, we're defining the barebones needed to create an object
# Read up on FactoryGirl for more info

FactoryGirl.define do

  # create dj factory
  factory :dj do
    net_id "jamesd"
    email "jamesd@lafayette.edu"
    dj_name "DEEJAY coconut"
    real_name "James Davadasa"
    description "I'm a bad DJ"

    # factory for djs with shows
    factory :dj_with_shows do
      #associate shows with djs
      after(:build) do |dj, evaluator|
        2.times do
          dj.shows << build(:show)
        end
      end
    end
  end


  # create show factory
  factory :show do
    title "Mango Radio Show"
    description  "this is a description for our show"

    # all shows need djs. This creates two more
    after(:build) do |show, evaluator|
      2.times do
        show.djs << build(:dj)
      end
    end
  end




  # create episode factory
  factory :episode do
  	name "wonderful episode"
  	recording_url "http://localhost"
  	downloadable true
  	online_listens 1000
  	description "wonderful episode here"
  	show # all episodes need a show 

    # all episodes need djs
    after(:build) do |episode, evaluator|
      2.times do
        episode.djs << build(:dj)
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
