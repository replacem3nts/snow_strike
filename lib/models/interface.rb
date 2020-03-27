class Interface
    attr_accessor :prompt, :user

    def initialize
        @prompt = TTY::Prompt.new   
    end

    def menu_message
        "What would you like to do?"
    end

    def welcome
        Art.welcome_image
        sleep(1)
    end

    def login_or_reg
        answer = prompt.select("Would you like to log in or register as a new user?") do |menu|
            menu.choice "Log in", -> {User.log_user_in}
            menu.choice "Register", -> {User.register_user}
        end
    end

    def lets_start_msg
        system 'clear'
        5.times {puts " "}
        prompt.say("Hello, #{user.username}. Let's get started!")
        5.times {puts " "}
        sleep(2)
    end

# Default table setup and settings below    
    def create_display_table(title, headings, rows)
        Terminal::Table.new :title=> title, :headings => headings, :rows => rows
    end

    def default_table_style
        {:alignment => :center, :padding_left => 2, :border_x => "=", :border_i => "x"}
    end


# Main menu methods below
    def main_menu
        system 'clear'
        main_dashboard_table
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Find mountain forecast", -> {mtn_forecast}
            menu.choice "Go to my trips", -> {my_trips}
            menu.choice "Go to favorites", -> {my_favorites}
            menu.choice "Go to account settings", -> {account_settings} 
            menu.choice "Quit", -> {return}
        end
    end

    def main_dashboard_table
        rows = mtn_list.map {|mtn| [mtn.name, mtn.state]}
        headings = ["Mountain", "State"]
        table = create_display_table("Main Menu", headings, rows)
        table.style = default_table_style
        table.align_column(0, :left)
        puts table
    end

    def mtn_list
        user.my_mtn_list
    end

# Find mountain forecast below
    def mtn_forecast
        mtn = find_mtn
        system 'clear'
        mtn_forecast_dashboard(mtn)
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Create a new trip here", -> {new_mtn_trip(mtn)}
            menu.choice "Add to favorites", -> {new_mtn_favorite(mtn)}
            menu.choice "Check another mountain", -> {mtn_forecast}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def mtn_forecast_dashboard(mtn)
        rows = [[mtn.name, mtn.state]]
        headings = ["Mountain", "State"]
        table = create_display_table("#{mtn.name} Forecast", headings, rows)
        table.style = default_table_style
        table.align_column(0, :left)
        puts table
    end

    def new_mtn_trip(mtn)
        user.new_trip(mtn)
        main_menu
    end

    def new_mtn_favorite(mtn)
        user.add_favorite(mtn)
        main_menu
    end

    def find_mtn
        system 'clear'
        Mountain.execute_search
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
        rows = user.mountains.reload.map {|mtn| [mtn.name, mtn.state]}
        headings = ["Mountain", "State"]
        table = create_display_table("My Favorites", headings, rows)
        table.style = default_table_style
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
        response = prompt.yes?("Are you sure you want to delete your account?")
        if response
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