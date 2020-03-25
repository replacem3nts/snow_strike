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

    def my_mtn_list
        fav_mtns = self.mountains
        fav_mtns << Mountain.five_by_snow
        fav_mtns.uniq[0..4]
    end
end



# do |q|
#                 q.validate(!User.find_username(:username))
#                 q.messages[:valid?] = "Sorry, someone has that username already"
#             end