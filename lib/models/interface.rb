class Interface
    attr_accessor :prompt, :user

    def initialize
        @prompt = TTY::Prompt.new
        
    end

    def welcome
        puts ":snowflake: Welcome to Snow Strike! :snowflake:"
    end

    def choose_login_or_register
        answer = prompt.select("Would you like to log in or register as a new user?", [
            "Log in",
            "Register"
        ])
        answer == "Log in" ? User.log_someone_in : User.create_new_user 
    end

    def main_menu
        prompt.say("Hello, #{user.username}. Let's get started!")

        nav_to = prompt.select("Where would you like to go?") do |dest|
            dest.enum '.'

            dest.choice "Find mountain forecast", 1
            dest.choice "My trips", 2
            dest.choice "My favorites", 3
            dest.choice "Account settings", 4
            dest.choice "Quit", 5
        end
        nav_to
    end

    def find_mtns
        search_crit = prompt.select("How would you like to search?") do |crit|
            crit.enum '.'

            crit.choice "Name"
            crit.choice "State"
            crit.choice "Zip Code"
        end
    end

    def my_trips
        self.user.trips.map {|trip| puts trip.name}
    end

    def my_favorites
        fav_action = prompt.select("How would you like to search?") do |crit|
            crit.enum '.'

            crit.choice "Add favorite"
            crit.choice "Remove favorite"
            crit.choice "View favorite"
            crit.choice "Main menu"
            crit.choice "Quit"
        end
    end

    def account_settings
        account_action = prompt.select("What would you like to do?") do |crit|
            crit.enum '.'

            crit.choice "Edit username", 1
            crit.choice "Edit hometown", 2
            crit.choice "Edit age", 3
            crit.choice "Delete account", 4
            crit.choice "Main menu", 5
            crit.choice "Quit", 5
        end

        case account_action
        when 1
            self.user.edit_username
        when 2
            self.user.edit_hometown
        when 3
            self.user.edit_age
        when 4
            puts "Delete account tbd"
        when 5
            main_menu
        else
            return
        end

    end

end