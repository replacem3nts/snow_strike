class Mountain < ActiveRecord::Base
    has_many :favorites
    has_many :trips
    has_one :forecast

    @@prompt = TTY::Prompt.new

    def self.search_method
        @@prompt.select("How would you like to search?") do |criteria|
            criteria.enum '.'

            criteria.choice "By name", :name
            criteria.choice "By state", :state
            criteria.choice "By zip Code", :zip_code
        end
    end

    def self.get_search
        @@prompt.ask("Please enter search term?")
    end

    def self.select_from_hash(hash)
        selection = @@prompt.select("Which mountain do you mean?", hash)
        find(selection)
    end

    def self.execute_search
        result = where({search_method=>get_search})
        choose_mtn = result.map {|mtn| {mtn.name => mtn.id}}
        if choose_mtn.count == 0
            puts "Sorry, that search didn't match any results."
            @@prompt.select("What would you like to do?") do |menu|
                menu.choice "Try again", -> {execute_search}
                menu.choice "Go back", -> {return}
            end
        else 
            choose_mtn.count > 1 ? select_from_hash(choose_mtn) : result.first
        end
    end

    def display_array
        [self.name, forecast.snow_this_yr, forecast.snow_next_three_days, forecast.snow_next_seven_days]
    end

    def self.five_by_snow
        order(hist_snow_per_year: :desc).limit(5)
    end
end