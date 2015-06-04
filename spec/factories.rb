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

    # add sub-factory for shows with episodes
    factory :show_with_episodes do

      # add episodes for shows
      after(:build) do |show, evaluator|
        10.times do
          show.episodes << build(:episode)
        end
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

    factory :episode_with_songs_and_airings do
    	#create songs and airings for episode
    	after(:build) do |episode, evaluator|
    		30.times do
          episode.songs << build(:song)
        end
        5.times do
          episode.airings << build(:airing)
        end
    	end

      factory :episode_with_songs_and_airings_and_shows do
        after(:build) do |episode, evaluator|
          episode.show = build(:show)
        end
      end

    end
  end




  # create airings factory
  factory :airing do
  	start_time Time.now
  	end_time Time.now + 1.hour
  	listens 1000
  end



  # create songs factory
  factory :song do
  	artist "James Dunn"
  	title "A Beaut Song"
  	ISRC "3432423234"
  end
end
