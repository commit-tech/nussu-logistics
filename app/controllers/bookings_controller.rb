class BookingsController < ApplicationController
  def index
    if can?(:show_full, User)
      @bookings = Booking.all.includes(:user, :item)
    else
      @bookings = Booking.where(user: current_user).includes(:user, :item)
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
    start_date = booking_params['start_date']
    start_timing = booking_params['start_timing']
    start_date = "#{start_date} #{start_timing}"
    my_start = DateTime.strptime(start_date, '%Y-%m-%d %H:%M')
    my_start = my_start.change(:offset => "+0800")

    end_date = booking_params['end_date']
    end_timing = booking_params['end_timing']
    end_date = "#{end_date} #{end_timing}"
    my_end = DateTime.strptime(end_date, '%Y-%m-%d %H:%M')
    my_end = my_end.change(:offset => "+0800")

    puts(my_start)
    puts(my_end)
    puts("hello")
    puts(booking_params)
    my_hash = { "description" => booking_params['description'],
    "start_time" => my_start,
    "end_time" => my_end,
    "quantity" => booking_params['quantity'], 
    "item_id" => booking_params['item_id']}
    puts("my_hash:")
    puts(my_hash)
    booking = Booking.new(my_hash)
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
    params.require(:booking).permit(:description, :start_time, :end_time, :quantity, :item_id, 
      :start_date, :end_date, :start_timing, :end_timing)
  end
end
