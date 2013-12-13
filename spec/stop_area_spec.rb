require 'spec_helper'

describe Transilien::StopArea do
  before(:each) do
    # This payload was generated from
    # http://ms.api.transilien.com/?Action=StopAreaList&StopAreaExternalCode=DUA8738400
    @sa = Transilien::StopArea.from_node(Nokogiri.XML((Pathname.new('spec') + 'stoparea_DUA8738400.xml').read).at('StopArea'), Time.now)
  end

  it 'should be a StopArea' do
    @sa.class.should eq(Transilien::StopArea)
  end

  it 'should have at least a line' do
    puts @sa.lines.map { |l| l.name }.inspect
    (@sa.lines.length >= 1).should be_true
  end

  it 'should have some codes, at least one' do
    @sa.codes.is_a?(Array).should be_true
    (@sa.codes.length > 0).should be_true
  end

end
