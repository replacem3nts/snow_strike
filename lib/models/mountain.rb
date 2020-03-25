class Mountain < ActiveRecord::Base
    has_many :favorites
    has_many :trips

    def self.find_mtn
        prompt = TTY::Prompt.new
        search_crit = prompt.select("How would you like to search?") do |crit|
            crit.enum '.'

            crit.choice "Name", 1
            crit.choice "State", 2
            crit.choice "Zip Code", 3
        end

        search = prompt.ask("What are you looking for?")

        case search_crit
        when 1
            self.find_by(name: search) || "Sorry, no matches. Try again."
        when 2
            self.find_by(state: search) || "Sorry, no matches. Try again."
        else
            self.find_by(zip_code: search) || "Sorry, no matches. Try again."
        end
    end

    def self.five_by_snow
        order(hist_snow_per_year: :desc).limit(5)
    end
end