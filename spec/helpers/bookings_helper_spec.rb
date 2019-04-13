require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BookingsHelper. For example:
#
# describe BookingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BookingsHelper, type: :helper do
  describe 'retrieve_bookings' do
    before do
      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @laptop = create(:item, name: "laptop", quantity: 2)
      @camera = create(:item, name: "camera", quantity: 5)

      @booking = create(:booking, item: @camera, quantity: 1, start_time: "2000-01-02 08:30:00", end_time: "2000-01-02 10:00:00")
      @booking2 = create(:booking, item: @camera, quantity: 2, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 13:00:00")
      @booking3 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 11:00:00")
      @booking4 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-01 15:00:00", end_time: "2000-01-03 15:00:00")
    end

    it 'retrieves correctly' do
      start_time = DateTime.strptime('02/01/2000 12:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('02/01/2000 08:30 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 1

      start_time = DateTime.strptime('02/01/2000 08:30 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('02/01/2000 09:30 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 2

      start_time = DateTime.strptime('02/01/2000 9:30 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('02/01/2000 10:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 4

      start_time = DateTime.strptime('02/01/2000 10:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('02/01/2000 11:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 3

      start_time = DateTime.strptime('02/01/2000 11:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('02/01/2000 01:00 PM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 2

      start_time = DateTime.strptime('02/01/2000 01:00 PM +08:00', '%d/%m/%Y %I:%M %p %z')
      end_time = DateTime.strptime('03/01/2000 12:00 AM +08:00', '%d/%m/%Y %I:%M %p %z')
      bookings = retrieve_bookings(start_time, end_time, Booking.all)
      expect(bookings.size()).to eq 1
    end

    after do
      Timecop.return
    end  

  end

  describe 'retrieve_period' do
    before do
      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @laptop = create(:item, name: "laptop", quantity: 2)
      @camera = create(:item, name: "camera", quantity: 5)

      @booking = create(:booking, item: @camera, quantity: 1, start_time: "2000-01-02 07:30:00", end_time: "2000-01-02 10:00:00")
      @booking2 = create(:booking, item: @camera, quantity: 2, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 13:00:00")
      @booking3 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 11:00:00")
      @booking4 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-01 15:00:00", end_time: "2000-01-03 15:00:00")
      @booking5 = create(:booking, status: 0, item: @camera, quantity: 1, start_time: "2000-01-02 10:30:00", end_time: "2000-01-02 17:00:00")
    end

    it 'retrieves correctly' do
      timings = retrieve_period("2000-01-02")

      expect(timings.size()).to eq(7)
      expect(timings.include?("2000-01-02 00:00:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 07:30:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 09:30:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 10:00:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 11:00:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 13:00:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 24:00:00 +08:00")).to be true
      expect(timings.include?("2000-01-02 10:30:00 +08:00")).to be false
      expect(timings.include?("2000-01-02 17:00:00 +08:00")).to be false
    end

    after do
      Timecop.return
    end  

  end

  describe 'duration_bookings' do
    before do
      freeze_time = DateTime.new(2000, 1, 1, 0)
      Timecop.freeze(freeze_time)

      @laptop = create(:item, name: "laptop", quantity: 2)
      @camera = create(:item, name: "camera", quantity: 5)

      @booking = create(:booking, item: @camera, quantity: 1, start_time: "2000-01-02 07:30:00", end_time: "2000-01-02 10:00:00")
      @booking2 = create(:booking, item: @camera, quantity: 2, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 13:00:00")
      @booking3 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-02 09:30:00", end_time: "2000-01-02 11:00:00")
      @booking4 = create(:booking, item: @laptop, quantity: 1, start_time: "2000-01-01 15:00:00", end_time: "2000-01-03 15:00:00")
      @booking5 = create(:booking, status: 0, item: @camera, quantity: 1, start_time: "2000-01-02 10:30:00", end_time: "2000-01-02 17:00:00")
    end

    it 'retrieves correctly' do
      hashes = duration_bookings("2000-01-02")
      expect(hashes.size()).to eq 6

      timings = retrieve_period("2000-01-02")
      idx = 1
      approved_bookings = Booking.where(status: 1)

      while idx < timings.size do
        a = timings[idx-1]
        b = timings[idx]
        expect(hashes.has_key?([a, b])).to be true
        expect(hashes[[a, b]]).to eq retrieve_bookings(a, b, approved_bookings)

        idx = idx + 1
      end  
    end

    after do
      Timecop.return
    end  
  end
end
