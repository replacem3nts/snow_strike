class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :skier_type
      t.string :hometown
      t.string :age
    end
  end
end
