class User < ActiveRecord::Base
    has_many :favorites
    has_many :trips

    def self.log_someone_in
        prompt = TTY::Prompt.new
        username = prompt.ask("Enter your username:")
        found_username = User.find_by(username: username)
        if found_username
            return found_username
        else
            puts "Sorry, that username doesn't exist!"
        end
    end

    def self.create_new_user
        prompt = TTY::Prompt.new
        username = prompt.ask("What would you like your username to be?")
        if find_by(username: username)
            puts "Sorry, somone has that username already"
        else
            create(username: username)
        end
    end
end