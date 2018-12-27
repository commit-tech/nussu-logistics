# frozen_string_literal: true

class DutiesController < ApplicationController
  def index
    @header_iter = generate_header_iter
    @start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                  .to_date
    @end_date = @start_date.to_date + 6.days
    @places = Place.all
  end

  def generate_duties
    start_date = (params[:start_date] || Time.zone.today.beginning_of_week)
                 .to_date
    end_date = start_date + (params[:num_weeks].to_i * 7 - 1).days
    Duty.generate(start_date, end_date)
    redirect_to duties_path(start_date: start_date),
                notice: 'Duties successfully generated!'
  end

  def open_drop_modal
    @users = User.where.not(id: current_user.id)
    @drop_duty_list = Duty.find(params[:drop_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def open_grab_modal
    @grab_duty_list = Duty.find(params[:grab_duty_list])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def grab
    if grabable?(params[:duty_id])
      duty_ids = params[:duty_id].keys

      Duty.find(duty_ids).each do |duty|
        duty.update(user: current_user, free: false, request_user: nil)
      end

      redirect_to duties_path, notice: 'Duty successfully grabbed!'
    else
      redirect_to duties_path, alert: 'Error in grabbing duty! ' \
        'Please try again.'
    end
  end

  def drop
    if owned_duties?(params[:duty_id], current_user)
      duty_ids = params[:duty_id].keys

      Duty.find(duty_ids).each do |duty|
        swap_user(params[:user_id].to_i, duty)
      end

      group_duties(duty_ids).each do |grouped_duty|
        drop_mail(params[:user_id].to_i, grouped_duty)
      end

      redirect_to duties_path, notice: 'Duty successfully dropped!'
    else
      redirect_to duties_path, alert: 'Error in dropping duty! ' \
        'Please try again.'
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

  private

  def owned_duties?(duty_id_params, supposed_user)
    duty_id_params.present? &&
      duty_id_params.keys.all? { |d| Duty.find(d).user == supposed_user }
  end

  def grabable?(duty_id_params)
    duty_id_params.present? && duty_id_params.keys.all? do |d|
      duty = Duty.find(d)
      duty.free ||
        duty.request_user == current_user ||
        (duty.request_user.present? && duty.user == current_user)
    end
  end

  def drop_mail(user_id, drop_duty)
    if user_id.zero?
      GenericMailer.drop_duty(drop_duty, User.pluck(:id))
    else
      GenericMailer.drop_duty(drop_duty, user_id)
                   .deliver_later
    end
  end

  def swap_user(swap_user_id, drop_duty)
    if swap_user_id.zero?
      drop_duty.update(free: true)
    else
      drop_duty.update(request_user_id: swap_user_id)
    end
  end

  def generate_header_iter
    time_range = TimeRange.order(:start_time)
    first_time = time_range.first.start_time
    last_time = time_range.last.end_time - 1.hour #Hardcoded
    first_time.to_i.step(last_time.to_i, 1.hour)
  end

end
