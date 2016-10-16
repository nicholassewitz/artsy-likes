module ArtworksHelper
  def edit_artwork_link(artwork)
  link_to('Edit', edit_artwork_path(artwork))
end

def delete_artwork_link(artwork)
  link_to('Delete', artwork, method: :delete, data: {confirm: 'Are you sure?'})
end
end
