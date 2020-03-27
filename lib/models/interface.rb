class Interface
    attr_accessor :prompt, :user

#user authentication & greeting sequence
    def initialize
        @prompt = TTY::Prompt.new   
    end

    def welcome
        system 'clear'
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
        Art.welcome_message(user.username)
        sleep(2)
    end

# Default table setup and settings
    def create_display_table(title, headings, rows)
        Terminal::Table.new :title=> title, :headings => headings, :rows => rows
    end

    def default_table_style
        {:alignment => :center, :padding_left => 2, :border_x => "=", :border_i => "x"}
    end

    def default_table_headings
        Forecast.display_headings
    end

    def populate_fcst(fcst)
        fcst.display_values_array
    end

    def menu_message
        "What would you like to do?"
    end

# Main menu methods
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
        rows = mtn_list.map {|fcst| populate_fcst(fcst)}
        headings = default_table_headings
        table = create_display_table("Main Menu", headings, rows)
        table.style = default_table_style
        table.align_column(0, :left)
        puts table
    end

    def mtn_list
        user.my_mtn_list
    end

# Find mountain forecast
    def mtn_forecast
        mtn = find_mtn
        fcst = mtn.forecast
        system 'clear'
        mtn_forecast_dashboard(fcst)
        prompt.select(menu_message) do |menu|
            menu.enum '.'

            menu.choice "Create a new trip here", -> {new_mtn_trip(mtn)}
            menu.choice "Add to favorites", -> {new_mtn_favorite(mtn)}
            menu.choice "Check another mountain", -> {mtn_forecast}
            menu.choice "Main menu", -> {main_menu}
            menu.choice "Quit", -> {return}
        end
    end

    def mtn_forecast_dashboard(fcst)
        rows = [populate_fcst(fcst)]
        headings = default_table_headings
        table = create_display_table("#{fcst.mountain.name} Forecast", headings, rows)
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

# Trips menu
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

# Favorites menu
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
        rows = user_fav_fcsts.map {|fcst| populate_fcst(fcst)}
        headings = default_table_headings
        table = create_display_table("My Favorites", headings, rows)
        table.style = default_table_style
        table.align_column(0, :left)
        puts table
    end

    def user_fav_fcsts
        user.mountains.reload.map {|mountain| mountain.forecast}
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

# Account settings menu
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
        rows = [display_account_array]
        headings = display_account_headings
        title = ["Account Settings"]
        table = Terminal::Table.new :title=>"Account Settings", :headings=>headings, :rows=>rows
        table.style = {:alignment => :center, :padding_left => 2, :border_i => "x", :width => 100}
        puts table
    end

    def display_account_headings
        User.display_account_headings
    end

    def display_account_array
        user.display_account_array
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
            Art.account_destroyed_msg
            sleep(2)
            return
        end
    end

    def user_destroy
        User.delete_account(self.user)
    end
end