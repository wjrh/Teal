FactoryGirl.define do
  # create show factory
  factory :show, class: Show do
    title "Mango RRadio Show"
    description  "this is a description for our show"

    transient do
        djs_count 5
        episodes_count 32
    end

    # add djs to shows
    # add shows to djs
    after(:build) do |show, evaluator|
        create_list(:dj, evaluator.djs_count, show: show)
        create_list(:episode, evaluator.episodes_count, show: show)
    end
  end


  # create dj factory
  factory :dj, class: Dj do
  	net_id "jamesd"
  	email "jamesd@lafayette.edu"
  	dj_name "DEEJAY coconut"
  	real_name "James Davadasa"
  	description "I'm a bad DJ"

  	factory :dj_with_shows do
	  	transient do
	  		shows_count 2
	  	end

	  	#associate shows with djs
	  	after(:create) do |show, evaluator|
	  		create_list(:show, evaluator.shows_count, dj: dj)
	  	end
	  end
  end

  # create episode factory
  factory :episode, class: Episode do
  	name "wonderful episode"
  	recording_url "http://localhost"
  	downloadable true
  	online_listens 1000
  	description "wonderful episode here"
  	show
  	djs

  	# create episdode with songs
  	transient do
  		songs_count 23
  		airings_count 2
  	end

  	#create songs for episode
  	after(:create) do |show, evaluator|
  		create_list(:song, evaluator.songs_count, episode: episode)
  		create_list(:airing, evaluator.airings_count, episode: episode)
  	end
  end

  # create airings factory
  factory :airing, class: Airing do
  	start_time Time.now
  	end_time Time.now + 1.hour
  	listens 1000
  end

  # create songs factory
  factory :song, class: Song do
  	artist "James Dunn"
  	title "A Beaut Song"
  	ISRC "3432423234"
  end
end
