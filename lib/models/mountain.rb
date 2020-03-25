class Mountain < ActiveRecord::Base
    has_many :favorites
    has_many :trips

    def self.five_by_snow
        order(hist_snow_per_year: :desc).limit(5)
    end
end