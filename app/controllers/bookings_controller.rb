class BookingsController < ApplicationController
  def index
    if can?(:show_full, User)
      @bookings = Booking.all
    else
      @bookings = Booking.where(user: current_user)
    end    
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def new
    @booking = Booking.new
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def create
    booking = Booking.new(booking_params)
    booking.status = :pending
    booking.user = current_user

    if booking.save
      redirect_to bookings_path,
                  notice: "Created new booking"
    else 
      @booking = booking
      flash.now[:alert] = "Failed to create booking:
                          #{booking.errors.full_messages.join(', ')}"
      render new_booking_path
    end  
  end

  def update
    @booking = Booking.find(params[:id])
    if params[:status]
      if @booking.update(params.permit(:status))
        redirect_to bookings_path,
                    notice: "#{@booking.status.capitalize} booking successfully"
      else 
        redirect_to bookings_path,
                    notice: "Failed. Booking still in #{@booking.status} state"
      end
    else
      if @booking.update(booking_params)
        redirect_to bookings_path,
                notice: "Updated booking"
      else 
        flash.now[:alert] = "Failed to update booking"
        render 'edit'
      end
    end  
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
 
    redirect_to bookings_path,
                notice: 'Deleted booking'

  end

  private

  def booking_params
    params.require(:booking).permit(:description, :start_time, :end_time, :quantity)
  end
end
