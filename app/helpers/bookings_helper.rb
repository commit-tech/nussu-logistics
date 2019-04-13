module BookingsHelper
  def duration_bookings(date)
    retrieve_period(date).each_cons(2).map{|timing| [timing, retrieve_bookings(timing[0], timing[1], Booking.all.where(status: 1))]}.to_h
  end  

  def retrieve_period(date)
    booked_today = Booking.where(status: 1)
                          .where("(start_time >= :start_time AND start_time <= :end_time) OR (end_time <= :end_time AND end_time >= :start_time) AND status = 1", start_time: date.to_datetime, end_time: date.to_datetime.tomorrow)
    period_booked_today = booked_today.pluck(:start_time)
    period_booked_today = period_booked_today + booked_today.pluck(:end_time)
    period_booked_today = period_booked_today + [date.to_datetime.change(:offset => "+0800"), date.to_datetime.tomorrow.change(:offset => "+0800")]
    return period_booked_today.uniq.sort.map(&:to_datetime)
  end

  def retrieve_bookings(start_time, end_time, bookings)
    return bookings.where("start_time <= :start_time AND end_time >= :end_time AND status = 1", start_time: start_time, end_time: end_time)
  end   
  
end
