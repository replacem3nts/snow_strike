class Interface
    attr_accessor :prompt, :user

    def initialize
        @prompt = TTY::Prompt.new
        
    end

    def menu_message
        "What would you like to do?"
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

# Main menu methods
    def main_menu
        system 'clear'
        prompt.say("Hello, #{user.username}. Let's get started!")

        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Find mountain forecast", -> {find_mtn}
            menu.choice "Go to my trips", -> {my_trips}
            menu.choice "Go to favorites", -> {my_favorites}
            menu.choice "Go to account settings", -> {account_settings} 
            menu.choice "Quit", -> {return}
        end
    end

# Find mountain forecast below
    def find_mtn
        system 'clear'
        sleep(1)
        Mountain.execute_search
        main_menu
    end

# Trips menu methods
    def my_trips
        display_trips
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Create a new trip", -> {new_trip}
            menu.choice "Edit a trip", -> {edit_trip}
            menu.choice "Remove a trip", -> {delete_trip}
            menu.choice "Quit", -> {return}
        end
    end

    def display_trips
        user.display_trips
    end

    def new_trip
        user.new_trip
        my_trips
    end

    def edit_trip
        user.edit_trip
        my_trips
    end

    def delete_trip
        user.delete_trip
        my_trips
    end


# Favorites menu methods
    def my_favorites
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Add favorite", -> {add_favorite}
            menu.choice "Remove favorite", -> {remove_favorite}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def add_favorite
        user.add_favorite
        my_favorites
    end

    def remove_favorite
        system 'clear'
        user.remove_favorite
        my_favorites
    end


# Account settings menu methods
    def account_settings
        system 'clear'
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Edit username", -> {edit_username}
            menu.choice "Edit hometown", -> {edit_hometown}
            menu.choice "Edit age", -> {edit_age}
            menu.choice "Delete account", -> {puts "Delete account tbd"}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def edit_username
        system 'clear'
        user.edit_username
        account_settings
    end

    def edit_hometown
        system 'clear'
        user.edit_hometown
        account_settings
    end

    def edit_age
        system 'clear'
        user.edit_age
        account_settings
    end
end