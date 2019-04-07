module BookingsHelper
  def day_bookings(date)
    times = retrieve_period(date)
    sz = times.size
    idx = 1;

    time1 = times[idx-1]
    time2 = times[idx]
    
    while idx < size
      time1 = times[idx-1]
      time2 = times[idx]
      timing = [[time1, time2]]

      result << timing
    end

    bookings = Bookings.where("(start_time <= :start_time AND end_time > :start_time) OR (start_time < :end_time AND end_time >= :end_time) AND status == 1", start_time: Time.now.beginning_of_day, end_time: Time.now.end_of_day)
    result = result.map{|timing| [timing, retrieve_bookings(timing[0], timing[1], bookings)]}.to_h
  end  

  def retrieve_period(date)
    date = Time.now
    booked_today = Bookings.where("(start_time <= :start_time AND end_time > :start_time) OR (start_time < :end_time AND end_time >= :end_time) AND status == 1", start_time: Time.now.beginning_of_day, end_time: Time.now.end_of_day)
    period_booked_today << booked_today.pluck(:start_time)
    period_booked_today << booked_today.pluck(:end_time)
    return period_booked_today.distinct.order
  end

  def retrieve_bookings(start_time, end_time)
    return Bookings.where("start_time <= :start_time AND end_time >= :end_time AND status == 1", start_time: start_time, end_time: end_time)
  end   
  
end
