module BookingsHelper
  def retrieve_bookings(start_time, end_time)
    return Bookings.where("start_time <= :start_time AND end_time >= :end_time", start_time: start_time, end_time: end_time)
  end   
end
