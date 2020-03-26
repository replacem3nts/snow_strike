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

    def lets_start_msg
        system 'clear'
        5.times {puts " "}
        prompt.say("Hello, #{user.username}. Let's get started!")
        5.times {puts " "}
        sleep(2)
    end

# Main menu methods
    def main_menu
        system 'clear'
        main_dashboard_table
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Find mountain forecast", -> {find_mtn}
            menu.choice "Go to my trips", -> {my_trips}
            menu.choice "Go to favorites", -> {my_favorites}
            menu.choice "Go to account settings", -> {account_settings} 
            menu.choice "Quit", -> {return}
        end
    end

    def main_dashboard_table
        rows = mtn_list.map do |mtn| 
            [mtn.name, mtn.state, mtn.hist_snow_per_year]
        end
        headings = ["Mountain", "State", "Hist. Snow / Yr"]
        table = Terminal::Table.new :title=> "Main Menu", :headings => headings, :rows => rows
        table.style = {:alignment => :center, :padding_left => 2, :border_x => "=", :border_i => "x"}
        table.align_column(0, :left)
        puts table
    end

    def mtn_list
        user.my_mtn_list
    end

# Find mountain forecast below
    def find_mtn
        system 'clear'
        Mountain.execute_search
        main_menu
    end

# Trips menu methods
    def my_trips
        system 'clear'
        trip_dashboard_table
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Create a new trip", -> {new_trip}
            menu.choice "Edit a trip", -> {edit_trip}
            menu.choice "Remove a trip", -> {delete_trip}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def trip_dashboard_table
        user.trip_dashboard_table
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
        system 'clear'
        favorites_dashboard
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Add favorite", -> {add_favorite}
            menu.choice "Remove favorite", -> {remove_favorite}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def favorites_dashboard
        rows = user.mountains.map do |mtn| 
            [mtn.name, mtn.state, mtn.hist_snow_per_year]
        end
        headings = ["Mountain", "State", "Hist. Snow / Yr"]
        table = Terminal::Table.new :title=> "My Favorites", :headings => headings, :rows => rows
        table.style = {:alignment => :center, :padding_left => 2, :border_x => "=", :border_i => "x"}
        table.align_column(0, :left)
        puts table
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
        settings_dashboard
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Edit username", -> {edit_username}
            menu.choice "Edit hometown", -> {edit_hometown}
            menu.choice "Edit age", -> {edit_age}
            menu.choice "Delete account", -> {delete_account}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def settings_dashboard
        rows = [[user.username, user.skier_type.capitalize!, user.hometown, user.age]]
        headings = ["Username", "Two Planks or One?", "Hometown", "Age"]
        title = ["Account Settings"]
        table = Terminal::Table.new :title=>"Account Settings", :headings=>headings, :rows=>rows
        table.style = {:alignment => :center, :padding_left => 2, :border_i => "x", :width => 100}

        puts table
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

    def delete_account
        response = TTY::Prompt.new.yes?("Are you sure you want to delete your account?")
        if response = "y"
            user_destroy
            system 'clear'
            puts "Sorry to see you go!"
            sleep(2)
            return
        end
    end

    def user_destroy
        User.delete_account(self.user)
    end
end