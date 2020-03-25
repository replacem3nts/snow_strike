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
        found_username = User.find_by(username: username)
        found_username ? (return found_username) : (puts "Sorry, that username doesn't exist!")
    end

    def self.create_new_user
        prompt = TTY::Prompt.new
        details = prompt.collect do
            key(:username).ask("What username would you like?", required: true)
            key(:skier_type).ask('Do you ski, snowboard, or both?', required: true)
            key(:hometown).ask("What's your hometown?", required: true)
            key(:age).ask('How old are you?', required: true)
        end
        create(
            username: details[:username], 
            skier_type: details[:skier_type], 
            hometown: details[:hometown], 
            age: details[:age]
            )
    end

# Populates mountains for the dashboard from favorites + remaining best to equal 5 total 
    def my_mtn_list
        fav_mtns = []
        fav_mtns << self.mountains
        fav_mtns << Mountain.five_by_snow
        fav_mtns.flatten.uniq[0..4]
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


end



# do |q|
#                 q.validate(!User.find_username(:username))
#                 q.messages[:valid?] = "Sorry, someone has that username already"
#             end