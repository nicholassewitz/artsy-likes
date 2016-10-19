class Addphotourl < ActiveRecord::Migration[5.0]
  def change
    add_column :artworks, :photourl, :string 
  end
end
