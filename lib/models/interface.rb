class Interface
    attr_accessor :prompt, :user

    def initialize
        @prompt = TTY::Prompt.new
        
    end

    def welcome
        File.readlines("./lib/models/ascii_art.txt") do |line|
            prints line
        end
    end

    def choose_login_or_register
        answer = prompt.select("Would you like to log in or register as a new user?") do |menu|
            menu.choice "Log in", -> {User.log_someone_in}
            menu.choice "Register", -> {User.create_new_user}
        end
    end

    def main_menu
        prompt.say("Hello, #{user.username}. Let's get started!")

        prompt.select("Where would you like to go?") do |menu|
            menu.enum '.'

            menu.choice "Find mountain forecast", -> {find_mtns}
            menu.choice "My trips", -> {my_trips}
            menu.choice "My favorites", -> {my_favorites}
            menu.choice "Account settings", -> {account_settings} 
            menu.choice "Quit", -> {return}
        end
    end

    def my_trips
        self.user.trips.map {|trip| puts trip.name}
    end

    def my_favorites
        prompt.select("How would you like to search?") do |menu|
            menu.enum '.'

            menu.choice "Add favorite", -> {self.user.add_favorite}
            menu.choice "Remove favorite", -> {self.user.remove_favorite}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def account_settings
        prompt.select("What would you like to do?") do |menu|
            menu.enum '.'

            menu.choice "Edit username", -> {self.user.edit_username}
            menu.choice "Edit hometown", -> {self.user.edit_hometown}
            menu.choice "Edit age", -> {self.user.edit_age}
            menu.choice "Delete account", -> {puts "Delete account tbd"}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

end