module HotelsHelper
  def edit_hotel_link(hotel)
  link_to('Edit', edit_hotel_path(hotel))
end

def delete_hotel_link(hotel)
  link_to('Delete', hotel, method: :delete, data: {confirm: 'Are you sure?'})
end
end
