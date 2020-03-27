class CreateForecasts < ActiveRecord::Migration[5.2]
  def change
    create_table :forecasts do |t|
      t.integer :mountain_id
      t.integer :hist_snow
      t.integer :snow_this_yr
      t.integer :snow_next_three_days
      t.integer :snow_next_seven_days
      t.date :year_start
      t.timestamps
    end
  end
end
