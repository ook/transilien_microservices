require 'spec_helper'

describe Transilien::Line do
  before(:each) do
    # This payload was generated from
    # http://ms.api.transilien.com/?Action=LineList&LineExternalCode=DUA800854046
    @line = Transilien::Line.from_node(Nokogiri.XML((Pathname.new('spec') + 'line_DUA800854046.xml').read).at('Line'), Time.now)
  end

  it 'should get a Line' do
    @line.class.should eql(Transilien::Line)
  end

  it 'should have a code' do
    @line.code.should eql('J')
  end

end
