require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe 'GET bookings#index' do
    before do
      sign_in create(:user)
    end

    it 'normal' do
      get :index
      should respond_with :ok
    end
  end

  describe 'POST bookings#create' do
    before do
      user = create(:user)
      sign_in user

      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @item = create(:item)
    end

    it 'should redirect to bookings_path and create new booking' do
      post :create, params: { booking:
                            { item_id: @item.id,
                              quantity: 1, 
                              start_time: DateTime.new(2030),
                              end_time: DateTime.new(2030) + 10.days} }
      should redirect_to bookings_path
      expect(Booking.exists?(quantity: 1, item: @item,
                             start_time: DateTime.new(2030), end_time: DateTime.new(2030) + 10.days)).to be true
    end

    it 'should redirect_to new_booking_path and not create new booking' do
      yesterday = DateTime.now.next_day(-1)
      half_hour_later = DateTime.now + 30.minutes
      tomorrow = DateTime.now.next_day
      two_days_later = DateTime.now.next_day(2)

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              start_time: tomorrow,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: -1,
                              start_time: tomorrow,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 1,
                              start_time: yesterday,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 1,
                              start_time: half_hour_later,
                              end_time: two_days_later} }
      assert_template :new

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 1,
                              start_time: two_days_later,
                              end_time: tomorrow} }
      assert_template :new

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 3,
                              start_time: two_days_later,
                              end_time: tomorrow} }
      assert_template :new

      expect(Booking.exists?(description: 'Failed')).to be false
    end 
    
    after do
      Timecop.return
    end
  end

  describe 'POST bookings#create quantity validation' do
    before do
      user = create(:user)
      user.add_role(:technical)
      sign_in user

      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @booking = create(:booking)
      @item = @booking.item
      @booking2 = create(:booking, item_id: @item.id, start_time: "2000-01-16 09:00:00", end_time: "2000-01-20 10:00:00" )
      @booking3 = create(:booking, item_id: @item.id, start_time: "2000-01-19 09:00:00", end_time: "2000-01-22 10:00:00" )
      @booking4 = create(:booking, item_id: @item.id, quantity: 2, start_time: "2000-02-19 09:00:00", end_time: "2000-02-22 10:00:00" )
    end

    it 'should redirect to bookings_path and create new booking' do
      post :create, params: { booking:
                            { item_id: @item.id,
                              quantity: 1, 
                              start_time: DateTime.new(2000, 1, 1, 9),
                              end_time: DateTime.new(2000, 1, 15, 9) } }
      should redirect_to bookings_path
      expect(Booking.exists?(quantity: 1, item: @item,
                             start_time: DateTime.new(2000, 1, 1, 9), end_time: DateTime.new(2000, 1, 15, 9) ) ).to be true
    end

    it 'should redirect to bookings_path and create new booking even with existing non-overlapping bookings' do
      post :create, params: { booking:
                            { item_id: @item.id,
                              quantity: 1, 
                              start_time: DateTime.new(2000, 1, 1, 9),
                              end_time: DateTime.new(2000, 1, 18, 9) } }
      should redirect_to bookings_path
      expect(Booking.exists?(quantity: 1, item: @item,
                             start_time: DateTime.new(2000, 1, 1, 9), end_time: DateTime.new(2000, 1, 18, 9) ) ).to be true
    end

    it 'should redirect_to new_booking_path and not create new booking' do
      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 2, 
                              start_time: DateTime.new(2000, 1, 1, 9),
                              end_time: DateTime.new(2000, 1, 15, 9) } }  
      assert_template :new
      expect(Booking.exists?(description: 'Failed')).to be false

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 1, 
                              start_time: DateTime.new(2000, 1, 17, 9),
                              end_time: DateTime.new(2000, 1, 23, 9) } }  
      assert_template :new
      expect(Booking.exists?(description: 'Failed')).to be false

      post :create, params: { booking:
                            { item_id: @item.id,
                              description: 'Failed',
                              quantity: 1, 
                              start_time: DateTime.new(2000, 2, 18, 9),
                              end_time: DateTime.new(2000, 2, 23, 9) } }  
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

  describe 'PATCH bookings#update' do
    before do
      sign_in create(:user)

      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @booking = create(:booking)
    end

    it 'should change the description and redirect' do
      expect do
        patch :update, params: { id: @booking.id, booking: {description: "I'm super duper Rich"} }
      end.to change { Booking.find(@booking.id).description }
        .to("I'm super duper Rich")
      should redirect_to bookings_path
    end

    it 'should not exceed the quantity and redirect' do
      expect do
        patch :update, params: { id: @booking.id, booking: { quantity: 3} }
        assert_template :edit
    end

    it 'should change the quantity and redirect' do
      expect do
        patch :update, params: { id: @booking.id, booking: { quantity: 2 } }
      end.to change { Booking.find(@booking.id).quantity }.to(2)
    end

    it 'should not change the quantity and redirect' do
      patch :update, params: { id: @booking.id, booking: { quantity: -1 } }
      assert_template :edit
    end

    it 'should change the start_time and redirect' do
      expect do
        patch :update, params: { id: @booking.id, booking: { start_time: DateTime.new(2000) + 10.days} }
      end.to change { Booking.find(@booking.id).start_time }.to(DateTime.new(2000) + 10.days)
    end

    it 'should not change the start_time and redirect' do
      patch :update, params: { id: @booking.id, booking: { start_time: DateTime.new(1999) } }
      assert_template :edit
    end

    it 'should change the end_time and redirect' do
      expect do
        patch :update, params: { id: @booking.id, booking: { end_time: DateTime.new(2000) + 2.months } }
      end.to change { Booking.find(@booking.id).end_time }.to(DateTime.new(2000) + 2.months)
    end

    it 'should not change the end_time and redirect' do
      patch :update, params: { id: @booking.id, booking: { end_time: DateTime.new(1999) } }
      assert_template :edit
    end

    after do
      Timecop.return
    end
  end


end

