module BookingsHelper
  def retrieve_bookings(start_time, end_time)
    return Bookings.where("start_time <= :start_time AND end_time >= :end_time", start_time: start_time, end_time: end_time)
  end   
  
  def retrieve_period(date)
    date = Time.now
    booked_today = Bookings.where(("start_time <= ? AND end_time >?", Time.now.begining_of_day) | ("start_time < ? AND end_time >=?", Time.now.end_of_day))
    period_booked_today[] = booked_today.pluck(:start_time, :end_time).distinct
    return  period_booked_today[]
  end
end
