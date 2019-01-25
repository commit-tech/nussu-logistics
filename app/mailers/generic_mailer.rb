# frozen_string_literal: true

class GenericMailer < ApplicationMailer
  default from: %("NUSSU commIT" <duty@#{ENV['MAILGUN_DOMAIN']}>)

  def drop_duty(duty_ids, user_ids)
    group_duties(duty_ids).each do |duty|
      mail(to: users_with_name(user_ids),
           subject: generate_drop_duty_subject(duty))
    end
  end

  def group_duties(duty_id_list)
    duty_list = Duty.find(duty_id_list).map{ |duty| {start_time: duty.time_range.start_time, 
      :end_time => duty.time_range.end_time, date: duty.date, place: duty.place.name}}
    result = [duty_list[0]]
    (1..duty_list.length - 1).each do |i|
      if (result[result.length - 1][:end_time] <=> duty_list[i][:start_time]) == 0
        result[result.length - 1][:end_time] = duty_list[i][:end_time]
      else
        result.push(duty_list[i])
      end
    end
    result
  end

  def problem_report(problem)
    @problem = problem
    mail(to: users_with_name(User.where(cell: 'technical').pluck(:id)),
         subject: 'New computer problem')
  end

  private

  def generate_drop_duty_subject(duty)
    'DUTY DUTY DUTY ' \
    "#{duty[:start_time].strftime('%H%M')}-" \
    "#{duty[:end_time].strftime('%H%M')} on " \
    "#{duty[:date].strftime('%a, %d %b %Y')} at " \
    "#{duty[:place]}"
  end

  def users_with_name(user_ids)
    User.find(user_ids)&.pluck(:username, :email)&.map do |u|
      %("#{u[0]}" <#{u[1]}>)
    end
  end
end
