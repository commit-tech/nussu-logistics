describe "TimeCop" do
  it "succeeds" do
    datetime = DateTime.new(2000, 1, 1)
    Timecop.freeze(datetime)
    expect(datetime).to eq(Time.now)
    Timecop.return
  end
end