class Changetablename < ActiveRecord::Migration[5.0]
  def change
    rename_table :hotels, :artworks
  end
end
