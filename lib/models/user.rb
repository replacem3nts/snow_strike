class User < ActiveRecord::Base
    has_many :favorites
    has_many :trips
    has_many :mountains, through: :favorites

    def self.find_username(username)
        find_by(username: username)
    end

    def self.log_someone_in
        prompt = TTY::Prompt.new
        username = prompt.ask("Enter your username:")
        found_username = find_by(username: username)
        found_username ? (return found_username) : (puts "Sorry, that username doesn't exist!")
    end

    def self.create_new_user
        prompt = TTY::Prompt.new
        user_details = prompt.collect do
            key(:username).ask("What username would you like?", required: true)
            key(:skier_type).ask('Do you ski, snowboard, or both?', required: true)
            key(:hometown).ask("What's your hometown?", required: true)
            key(:age).ask('How old are you?', required: true)
        end
        create(
            username: user_details[:username], 
            skier_type: user_details[:skier_type], 
            hometown: user_details[:hometown], 
            age: user_details[:age]
            )
    end

# Populates mountains for the dashboard from favorites + remaining best to equal 5 total 
    def my_mtn_list
        fav_mtns = []
        fav_mtns << self.mountains
        fav_mtns << five_mtns_by_snow
        fav_mtns.flatten.uniq[0..4]
    end

# Trip menu functions below
    def display_trips
        trips.all.each {|trip| puts "#{trip.name} from #{trip.start_date} until #{trip.end_date} at #{trip.name}"}
    end

    def list_of_trips
        trips.map {|trip| {trip.name => trip.id}}
    end

    def new_trip
        prompt = TTY::Prompt.new
        trip_details = prompt.collect do
            key(:name).ask("What would you like to call this trip?", required: true)
            key(:start_date).ask('When would you like to go?', required: true)
            key(:end_date).ask("When will you come back?", required: true)
        end
        puts "Okay, let's find a mountain to go to!"
        trip_mtn = mtn_search
        create_trip(
            trip_details[:name], 
            trip_details[:start_date], 
            trip_details[:end_date],
            trip_mtn
        )
    end

    def edit_trip
    end

    def delete_trip
        trip_to_remove = TTY::Prompt.new.select("Which trip would you like to remove?", list_of_trips)
        destroy_trip(trip_to_remove)
    end


# Favorites menu functions below
def add_favorite
    if self.favorites.count > 4
        puts "Sorry, you already have 5 favorites, please remove one first."
        remove_favorite
        puts "Okay, let's add that mountain!"
    end

    new_fav = mtn_search
    self.mountains.include?(new_fav) ? (puts "Sorry that's already a favorite") : create_fav(new_fav)
end

def remove_favorite
    prompt = TTY::Prompt.new
    fav_list = self.favorites.map {|favorite| {favorite.mountain.name => favorite.id} }
    faves_to_remove = prompt.multi_select("Which mountain would you like to remove?", fav_list)
    destroy_array_of_faves(faves_to_remove)
end

# Account settings functions below
    def edit_username
        prompt = TTY::Prompt.new
        new_name = prompt.ask("What do you want to change your username to?")
            
        !User.find_username(new_name) ? self.update(username: new_name) : (puts "Sorry that username is taken.")
    end

    def edit_hometown
        prompt = TTY::Prompt.new
        new_home = prompt.ask("What's your new hometown?")
        self.update(hometown: new_home)
    end

    def edit_age
        prompt = TTY::Prompt.new
        new_age = prompt.ask("How old are you now?")
        self.update(age: new_age)
    end

    private

#Links to other classes
    def five_mtns_by_snow
        Mountain.five_by_snow
    end

    def mtn_search
        Mountain.execute_search
    end

    def create_fav(mtn)
        Favorite.create(user_id: self.id, mountain_id: mtn.id)
    end

    def destroy_array_of_faves(array)
        Favorite.remove_array_of_favorites(array)
    end

    def destroy_trip(trip_id)
        Trip.destroy(trip_id)
    end

    def create_trip(name, start, finish, mountain)
        Trip.create(name: name, start_date: start, end_date: finish, mountain_id: mountain.id, user_id: self.id)
    end
end



