class HotelsController < ApplicationController
	before_action(:authenticate_user!, except: [:index, :show])
	before_action(:find_hotel, only: [:show, :edit, :update, :destroy])

	def index
		@hotels = Hotel.all
	end

	def new
		@hotel = Hotel.new
	end

	def show
		find_hotel
	end

	def create
		@hotel = current_user.hotels.create(hotel_params)
		redirect_to_hotel_if_valid('You successfully created a hotel!')
	end

	def update
		@hotel.update(hotel_params)
		redirect_to_hotel_if_valid('You successfully updated your hotel!')
	end

	def destroy
		@hotel.destroy
		redirect_to(hotels_path, alert: 'The hotel was deleted!')
	end

	def search
		@hotels = Hotel.search(params[:query])
	end

	private

	def find_hotel
		@hotel = Hotel.find(params[:id])
	end

	def hotel_params
		permitted_params = [:name, :description, :street, :city, :state, :zip, :country, :photo]
		permitted_params.push(:user_id) if admin?

		params[:hotel].permit(permitted_params)
	end

	def redirect_to_hotel_if_valid(notice)
		redirect_to_hotel(notice) if @hotel.valid?
	end

	def redirect_to_hotel(notice)
		redirect_to(@hotel, notice: notice)
	end

end
