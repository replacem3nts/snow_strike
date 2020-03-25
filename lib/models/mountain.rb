class Mountain < ActiveRecord::Base
    has_many :favorites
    has_many :trips

    def self.search_method
        TTY::Prompt.new.select("How would you like to search?") do |criteria|
            criteria.enum '.'

            criteria.choice "Name", :name
            criteria.choice "State", :state
            criteria.choice "Zip Code", :zip_code
        end
    end

    def self.get_search
        TTY::Prompt.new.ask("Please enter search term?")
    end

    def self.select_from_hash(hash)
        selection = TTY::Prompt.new.select("Which mountain do you mean?", hash)
        find(selection)
    end

    def self.execute_search
        result = self.where({search_method=>get_search})
        choose_mtn = result.map {|mtn| {mtn.name => mtn.id}}
        if choose_mtn.count == 0
            puts "Sorry, that search didn't match any results."
            TTY::Prompt.new.select("What would you like to do?") do |menu|
                menu.choice "Try again", -> {execute_search}
                menu.choice "Go back", -> {return}
            end
        else 
            choose_mtn.count > 1 ? select_from_hash(choose_mtn) : result.first
        end
    end

    def self.five_by_snow
        order(hist_snow_per_year: :desc).limit(5)
    end
end