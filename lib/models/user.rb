class User < ActiveRecord::Base
    has_many :favorites
    has_many :trips
    has_many :mountains, through: :favorites

    def self.find_username(username)
        find_by username: username
    end

    def self.log_someone_in
        system 'clear'
        prompt = TTY::Prompt.new
        username = prompt.ask("Enter your username:")
        found_username = find_username(username)
        found_username ? (return found_username) : (puts "Sorry, that username doesn't exist!")
    end

    def self.create_new_user
        system 'clear'
        prompt = TTY::Prompt.new
        user_details = prompt.collect do
            key(:username).ask("What username would you like?", required: true)
            key(:skier_type).ask('Do you ski, snowboard, or both?', required: true)
            key(:hometown).ask("What's your hometown?", required: true)
            key(:age).ask('How old are you?', required: true)
        end
        create(user_details)
    end

# Populates mountains for the main menu dashboard from favorites + remaining best to equal 5 total 
    def my_mtn_list
        fav_mtns = []
        fav_mtns << self.mountains
        fav_mtns << five_mtns_by_snow
        fav_mtns.flatten.uniq[0..4]
    end

# Trip menu functions below
    def trip_dashboard_table
        rows = trips.all.map {|trip| [trip.name, trip.start_date, trip.end_date, trip.mountain.name]}
        headings = ["Trip", "Start Date", "End Date", "Mountain"]

        table = Terminal::Table.new :title=>"My Trips",:headings => headings, :rows => rows
        table.style = {:alignment => :center, :padding_left => 2, :border_x => "=", :border_i => "x"}
        table.align_column(0, :left)
        puts table
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
        trip_details[:mountain_id] = mtn_search.id
        create_trip(trip_details)
    end

    def edit_mtn(array)
        array.pop
        puts "Okay, let's choose a new mountain!"
        {:mountain_id => mtn_search.id}
    end


    def detail_edit_prompt(detail)
        query_d = detail.to_s.gsub("_"," ")
        TTY::Prompt.new.ask("What would you like your new #{query_d} to be?")
    end

    def edit_trip
        prompt = TTY::Prompt.new
        trip_to_edit = prompt.select("Which trip would you like to change?", list_of_trips)

        details = {"Name"=>:name, "Start Date"=>:start_date, "End Date"=>:end_date, "Mountain"=>:mountain}
        details_to_edit = prompt.multi_select("Which parts of the trip would you like to change?", details)
        
        new_mtn = edit_mtn(details_to_edit) if details_to_edit.include?(:mountain)

        new_trip_details = {}
        details_to_edit.each {|detail| new_trip_details[detail] = detail_edit_prompt(detail)}

        new_trip_details.merge!(new_mtn) if new_mtn
        update_trip(trip_to_edit, new_trip_details)
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
    fav_list = self.favorites.map {|favorite| {favorite.mountain.name => favorite.id} }
    faves_to_remove = TTY::Prompt.new.multi_select("Which mountain would you like to remove?", fav_list)
    destroy_array_of_faves(faves_to_remove)
end

# Account settings functions below
    def edit_username
        new_name = TTY::Prompt.new.ask("What do you want to change your username to?")
        !User.find_username(new_name) ? self.update(username: new_name) : (puts "Sorry that username is taken.")
    end

    def edit_hometown
        new_home = TTY::Prompt.new.ask("What's your new hometown?")
        self.update(hometown: new_home)
    end

    def edit_age
        new_age = TTY::Prompt.new.ask("How old are you now?")
        self.update(age: new_age)
    end
    
    private

    def self.delete_account(account)
        self.destroy(account.id)
    end

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

    def update_trip(id_of_trip_to_edit, new_trip_details)
        Trip.find(id_of_trip_to_edit).update(new_trip_details)
    end

    def create_trip(trip_details)
        trip_details[:user_id] = self.id
        Trip.create(trip_details)
    end
end



