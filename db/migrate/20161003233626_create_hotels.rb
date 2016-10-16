class CreateHotels < ActiveRecord::Migration[5.0]
  def change
    create_table :hotels do |t|
      t.string :name, :location
      t.text :description
      t.attachment :photo
      t.integer :user_id

      t.timestamps
    end
  end
end
