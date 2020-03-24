class CreateMountains < ActiveRecord::Migration[5.2]
  def change
    create_table :mountains do |t|
      t.string :name
      t.string :state
      t.integer :zip_code
      t.integer :hist_snow_per_year
    end
  end
end
