class BookingsController < ApplicationController
  def index
    @bookings = Booking.all

    if can?(:show_full, User)
      @bookings = @bookings.includes(:user, :item)
    else
      @bookings = @bookings.where(user: current_user).includes(:user, :item)
    end    

    if params[:all_bookings]
      @filter = 'All'
    elsif params[:rejected_bookings]
      @filter = 'Rejected'
      @bookings = @bookings.where(
        status: "rejected"
      ).includes(:user, :item)
    elsif params[:approved_bookings]
      @filter = 'Approved'
      @bookings = @bookings.where(
        status: "approved"
      ).includes(:user, :item)
    else
      @filter = 'Pending'
      @bookings = @bookings.where(
        status: "pending"
      ).includes(:user, :item)
    end

    if params[:items]
      @item_list = params[:items]
      @bookings = @bookings.where(
        item_id: @item_list
      ).includes(:user, :item)
    else 
      @item_list = Item.all.pluck(:id)
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
    elsif params[:items]
      puts 'here'
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
    params.require(:booking).permit(:description, :start_time, :end_time, :quantity, :item_id)
  end
end
