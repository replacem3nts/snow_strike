class Interface
    attr_accessor :prompt, :user

    def intitialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        binding.pry
        puts ":snowflake: Welcome to Snow Strike! :snowflake:"
    end

    def choose_login_or_register
        answer = prompt.select("Would you like to log in or register as a new user?", [
            "Log in",
            "Register"
        ])

        if answer == "Log in"
            User.log_someone_in
        elsif answer == "Register"
            User.create_new_user
        end
    end

    def main_menu
        puts "Hello, welcome to Snow Strike, #{user.username}!"
        puts "Let's get started"
    end
end