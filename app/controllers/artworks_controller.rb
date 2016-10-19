class ArtworksController < ApplicationController
	before_action(:authenticate_user!, except: [:index, :show])
	before_action(:find_artwork, only: [:show, :edit, :update, :destroy])

	def index
		@artworks = Artwork.all
	end

	def new
		@artwork = Artwork.new
	end

	def show
		find_artwork
	end

	def create
		@artwork = current_user.artworks.create(artwork_params)
		redirect_to_artwork_if_valid('You successfully created a artwork!')
	end

	def update
		@artwork.update(artwork_params)
		redirect_to_artwork_if_valid('You successfully updated your artwork!')
	end

	def destroy
		@artwork.destroy
		redirect_to(artworks_path, alert: 'The artwork was deleted!')
	end

	def search
		@artworks = Artwork.search(params[:query])
	end

	private

	def find_artwork
		@artwork = Artwork.find(params[:id])
	end

	def artwork_params
		permitted_params = [:name, :description, :photo]
		permitted_params.push(:user_id) if admin?

		params[:artwork].permit(permitted_params)
	end

	def redirect_to_artwork_if_valid(notice)
		redirect_to_artwork(notice) if @artwork.valid?
	end

	def redirect_to_artwork(notice)
		redirect_to(@artwork, notice: notice)
	end

end
