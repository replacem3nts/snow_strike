class CreateTrip < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :mountain_id
      t.integer :user_id
    end
  end
end
