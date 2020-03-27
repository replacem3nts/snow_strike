class Forecast < ActiveRecord::Base
    belongs_to :mountain

    def self.display_headings
        ["Mountain", "State", "Hist Snow/Yr", "Snow to Date", "% vs. Hist", "FCST: Next 3", "FCST: Next 7"]
    end

    def display_values_array
        [mountain.name, mountain.state, hist_snow, snow_this_yr, (snow_this_yr/hist_snow.to_f).truncate(3)*100, snow_next_three_days, snow_next_seven_days]
    end

    def self.five_by_snow
        order(snow_this_yr: :desc).limit(5)
    end

    # def self.create_all_forecasts
    #     get_mountains.each {|mountain| create_forecast(mountain)}
    # end

    # def self.create_forecast(mountain)
    #     zip_code = mountain.zip_code
    #     create(
    #         mountain_id: mountain.id, 
    #         hist_snow: 0, 
    #         snow_this_yr: query_total_snow(zip_code), 
    #         snow_next_three_days: query_next_three(zip_code), 
    #         snow_next_seven_days: query_next_seven(zip_code),
    #         year_start: Date.new(2019,11,28)
    #         )
    # end

    def self.query_next_three(zip_code)
        forecast_query(zip_code).slice(0,3).sum
    end

    def self.query_next_seven(zip_code)
        forecast_query(zip_code).sum
    end

    def self.forecast_query(zip_code)
        DataQuery.get_forecast(zip_code, 7)
    end

    def self.query_total_snow(zip_code)
        DataQuery.get_total_snow(zip_code)
    end

    def self.get_mountains
        Mountain.all
    end
end