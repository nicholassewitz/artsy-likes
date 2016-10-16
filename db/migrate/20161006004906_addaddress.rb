class Addaddress < ActiveRecord::Migration[5.0]
  def change
    add_column :hotels, :street, :string
    add_column :hotels, :city, :string
    add_column :hotels, :country, :string
    add_column :hotels, :zip, :string
    add_column :hotels, :state, :string
    remove_column :hotels, :location

  end
end
