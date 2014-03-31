require 'spec_helper'

describe Transilien::Time do
  it 'should convert to ::Time easily' do
    tt = Transilien::Time.new
    tt.day = 0
    tt.hour = 14
    tt.minute = 42
    tt.time.is_a?(::Time).should be_true
    now = Time.new
    tt.time.should eql(Time.local(now.year, now.month, now.day, 14, 42))
    tt.day = 1
    this_month_days_count = Date.new(now.year, now.month, -1).day
    if now.day == this_month_days_count
      tt.time.should eql(Time.local(now.year, now.month+1, 1, 14, 42))
    else
      tt.time.should eql(Time.local(now.year, now.month, now.day+1, 14, 42))
    end
  end

end
