class CreateTrip < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :mountain_id
      t.integer :user_id
    end
  end
end
