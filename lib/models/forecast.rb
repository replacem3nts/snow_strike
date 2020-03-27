class Forecast < ActiveRecord::Base
    belongs_to :mountain

    






    def self.query_to_next_three_field(query)
        query.slice(0,3).sum
    end

    def self.query_to_next_seven_field(query)
        query.sum
    end

    def self.forecast_query(zip_code, days)
        DataQuery.get_forecast(zip_code, days)
    end
end