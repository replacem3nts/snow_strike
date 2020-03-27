class DataQuery

    # http://api.weatherstack.com/historical
    # ? access_key = YOUR_ACCESS_KEY
    # & query = New York
    # & historical_date_start = 2015-01-21
    # & historical_date_end = 2015-01-25
    def self.curr_yr_dates
        [["2019-11-28", "2020-01-17"], ["2020-01-18", "2020-03-08"], ["2020-03-09", "2020-03-25"]]
    end

    def self.get_total_snow(zip_code)
        total_snow = []
        curr_yr_dates.each do |date_pair|
            url = build_historical_query(zip_code, date_pair.first, date_pair.last)
            historical = get_and_parse(url)
            total_snow << convert_result_to_array(historical, "historical")
        end
        total_snow.flatten.sum
    end

    def self.build_historical_query(zip_code, start_date, end_date)
        "http://api.weatherstack.com/historical?access_key=9a215f3a399fae80814d763e208814c0&query=#{zip_code}&historical_date_start=#{start_date}&historical_date_end=#{end_date}&units=f"
    end

    def self.build_forecast_query(zip_code, days)
        "http://api.weatherstack.com/forecast?access_key=9a215f3a399fae80814d763e208814c0&query=#{zip_code}&forecast_days=#{days}&units=f"
    end
    
    def self.convert_result_to_array(response, type)
        snow_array = []
        response[type].each {|date, key| snow_array << key["totalsnow"]}
        snow_array
    end

    def self.get_forecast(zip_code, days)
        url = build_forecast_query(zip_code, days)
        forecast = get_and_parse(url)
        convert_result_to_array(forecast, "forecast")
    end

    def self.get_and_parse(url)
        response = HTTParty.get(url)
        JSON.parse(response.body)
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