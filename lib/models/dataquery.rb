class DataQuery

    # http://api.weatherstack.com/historical
    # ? access_key = YOUR_ACCESS_KEY
    # & query = New York
    # & historical_date_start = 2015-01-21
    # & historical_date_end = 2015-01-25



    def self.build_forecast_query(zip_code, start_date, end_date)
        "http://api.weatherstack.com/historical?access_key=9a215f3a399fae80814d763e208814c0&query=#{zip_code}&historical_date_start=#{start_date}&historical_date_end=#{end_date}&units=f"
    end

    def self.build_forecast_query(zip_code, days)
        "http://api.weatherstack.com/forecast?access_key=9a215f3a399fae80814d763e208814c0&query=#{zip_code}&forecast_days=#{days}&units=f"
    end
    
    def self.convert_forecast_to_array(forecast)
        snow_array = []
        forecast["forecast"].each {|date, key| snow_array << key["totalsnow"]}
        snow_array
    end

    def self.get_forecast(zip_code, days)
        url = self.build_forecast_query(zip_code, days)
        response = HTTParty.get(url)
        forecast = JSON.parse(response.body)
        convert_forecast_to_array(forecast)
    end


    def self.get_dates
        dates = []
        today = Date.today
        dates << today
        i = 1
        while i < 8 do
            dates << (today + i)
            i += 1
        end
        dates.map {|date| date.strftime("%Y-%m-%d")}
    end

end