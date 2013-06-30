require 'spec_helper'
describe Transilien::MicroService do
  it 'should generate empty params for nothing' do
    Transilien::MicroService.filters = {}
    Transilien::MicroService.params.empty?.should eq(true)
  end

  it 'should generate correct params for one simple filter' do
    Transilien::MicroService.filters = {:network_external_code => 'DU804'}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804'})
  end

  it 'should generate correct params for two simple filters' do
    Transilien::MicroService.filters = {:network_external_code => 'DU804', :route_external_code => 'DUA8008030781013'}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804', 'RouteExternalCode' => 'DUA8008030781013'})
  end

  it 'should generate correct params for one simple filter with Array, or is the default logic operator for arrays' do
    Transilien::MicroService.filters = {:network_external_code => ['DU804', 'DU805']}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804;DU805|or'})
  end

  it 'should generate correct params for two simple filters with Array, or is the default logic operator for arrays' do
    Transilien::MicroService.filters = {:network_external_code => ['DU804', 'DU805'], :route_external_code => ['DUA8008030781013', 'DUA8008031050001']}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804;DU805|or', 'RouteExternalCode' => 'DUA8008030781013;DUA8008031050001|or'})
  end

  it 'should generate correct params for one complex filter' do
    Transilien::MicroService.filters = {:network_external_code => { :and => ['DU804', 'DU805']}}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804;DU805|and'})
  end

  it 'should generate correct params for two complex filters' do
    Transilien::MicroService.filters = {:network_external_code => { :and => ['DU804', 'DU805']}, :route_external_code => { :or => ['DUA8008030781013', 'DUA8008031050001']}}
    Transilien::MicroService.params.should eq({'NetworkExternalCode' => 'DU804;DU805|and', 'RouteExternalCode' => 'DUA8008030781013;DUA8008031050001|or'})
  end
end
