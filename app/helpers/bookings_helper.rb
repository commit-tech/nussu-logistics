module BookingsHelper
  def day_bookings(date)
    times = retrieve_period(date)
    sz = times.size
    idx = 1;

    time1 = times[idx-1]
    time2 = times[idx]
    result = []
    
    while idx < sz
      time1 = times[idx-1]
      time2 = times[idx]
      timing = [[time1, time2]]

      result = result + timing
      idx = idx + 1
    end

    puts result

    bookings = Booking.where("(start_time >= :start_time AND start_time <= :end_time) OR (end_time <= :end_time AND end_time >= :start_time) AND status = 1", start_time: date.to_datetime, end_time: date.to_datetime.tomorrow)
    result = result.map{|timing| [timing, retrieve_bookings(timing[0], timing[1], bookings)]}.to_h
  end  

  def retrieve_period(date)
    booked_today = Booking.where("(start_time >= :start_time AND start_time <= :end_time) OR (end_time <= :end_time AND end_time >= :start_time) AND status = 1", start_time: date.to_datetime, end_time: date.to_datetime.tomorrow)
    period_booked_today = booked_today.pluck(:start_time)
    period_booked_today = period_booked_today + booked_today.pluck(:end_time)
    period_booked_today = period_booked_today + [date.to_datetime, date.to_datetime.tomorrow]
    return period_booked_today.uniq.sort
  end

  def retrieve_bookings(start_time, end_time, bookings)
    return bookings.where("start_time <= :start_time AND end_time >= :end_time AND status = 1", start_time: start_time, end_time: end_time)
  end   
  
end
