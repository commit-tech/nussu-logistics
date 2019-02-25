require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe 'GET problem_reports#index' do
    before do
      sign_in create(:user)
    end

    it 'normal' do
      get :index
      should respond_with :ok
    end
  end

  describe 'POST problem_reports#create' do
    before do
      user = create(:user)
      user.add_role(:technical)
      sign_in user

      Timecop.freeze(2000)
    end

    it 'should redirect to bookings_path and create new booking' do
      post :create, params: { booking:
                            { quantity: 5, 
                              start_time: DateTime.new(2030),
                              end_time: DateTime.new(2031)} }
      should redirect_to bookings_path
      expect(Booking.exists?(quantity: 5,
                             start_time: DateTime.new(2030), end_time: DateTime.new(2031))).to be true
    end

    it 'should redirect_to new_booking_path and not create new booking' do
      yesterday = DateTime.now.next_day(-1)
      half_hour_later = DateTime.now + Rational(1/48)
      tomorrow = DateTime.now.next_day
      two_days_later = DateTime.now.next_day(2)

      post :create, params: { booking:
                            { description: 'Failed',
                              start_time: tomorrow,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { description: 'Failed',
                              quantity: -1,
                              start_time: tomorrow,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { description: 'Failed',
                              quantity: 1,
                              start_time: yesterday,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { description: 'Failed',
                              quantity: 1,
                              start_time: half_hour_later,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { description: 'Failed',
                              quantity: 1,
                              start_time: two_days_later,
                              end_time: tomorrow} }
      assert_template :new

      expect(Booking.exists?(description: 'Failed')).to be false
    end

    after do
      Timecop.return
    end  
  end

  describe 'GET bookings#new' do
    before do
      sign_in create(:user)
      get :new
    end

    it { should respond_with :ok }
  end

  describe 'PATCH problem_reports#update' do
    before do
      sign_in create(:user)
      Timecop.freeze(2000)
    end

    it 'should change the description and redirect' do
      @booking = create(:booking)
      expect do
        patch :update, params: { id: @booking.id, booking: {description: "I'm super duper Rich"} }
      end.to change { Booking.find(@booking.id).description }
        .to("I'm super duper Rich")
      should redirect_to bookings_path
    end

    it 'should change the quantity and redirect' do
      @booking = create(:booking)
      expect do
        patch :update, params: { id: @booking.id, booking: { quantity: 2 } }
      end.to change { Booking.find(@booking.id).quantity }.to(2)
    end

    it 'should change the start_time and redirect' do
      @booking = create(:booking)
      expect do
        patch :update, params: { id: @booking.id, booking: { start_time: DateTime.new(2020) } }
      end.to change { Booking.find(@booking.id).start_time }.to(DateTime.new(2020))
    end

    it 'should change the end_time and redirect' do
      @booking = create(:booking)
      expect do
        patch :update, params: { id: @booking.id, booking: { end_time: DateTime.new(2040) } }
      end.to change { Booking.find(@booking.id).end_time }.to(DateTime.new(2040))
    end

    after do
      Timecop.return
    end
  end


end
