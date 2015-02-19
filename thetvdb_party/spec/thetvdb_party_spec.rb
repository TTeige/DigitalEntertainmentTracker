require 'thetvdb_party'

describe 'Client.search' do

  before(:each) do
    @client = TheTvDbParty::Client.new("5CB46CA60629B0DD")
  end

  it 'should return matches for "The Mentalist"' do
    matches = @client.search "The Mentalist"
    expect matches.count > 0
  end

  it 'should return more than one match for "Star Trek"' do
    matches = @client.search "Star Trek"
    expect matches.count > 1
  end
end

describe 'Client.get_base_series_record' do
  before(:each) do
    @client = TheTvDbParty::Client.new("5CB46CA60629B0DD")
  end

  it 'should return records that match the search result' do
    matches = @client.search "Star Trek"
    matches.each do |ssr|
      bsr = @client.get_base_series_record(ssr.seriesid)
      expect bsr.seriesname == ssr.seriesname
    end
  end
end
