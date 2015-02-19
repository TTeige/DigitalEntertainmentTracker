module TheTvDbParty
  # Represents one record within the search results for a series search
  # @example Getting a list of search results from a client
  #   results = TheTvDbParty::Client.new(nil).search "The Mentalist"
  # @example Using the search result record to fetch the Base Series Record
  #   base_series_record = TheTvDbParty::Client.new(nil).get_base_series_record search_series_record.seriesid
  class SearchSeriesRecord

    attr_reader :client
    attr_reader :id, :seriesid, :language, :seriesname, :aliasnames, :bannerpath_relative, :overview, :firstaired, :imdb_id, :zap2it_id, :network, :bannerpath_full

    # Initializes a new Search Series Record as is was retrieved from the TheTvDb API
    # @param [TheTvDbParty::Client] client The client instance that retrieved the record
    # @param [Hash{String => String}] hashValues A Hash instance that maps the record attribute element names against their values represented as strings.
    def initialize(client, hashValues)
      @client = client
      @hashValues = hashValues
    end

    # The client instance that retrieved this record
    # @return [TheTvDbParty::Client]
    def client; @client end

    # The unique TheTvDb identifier to access the more detailed Base Series Record and Full Series Record
    # @deprecated {#id} is only included to be backwards compatible with the old API and is deprecated.
    # @return [Fixnum] Returns an unsigned integer, or -1 if the record is invalid
    # @see #seriesid
    def id; @hashValues["id"] ? @hashValues["id"].to_i : -1 end

    # The unique TheTvDb identifier to access the more detailed Base Series Record and Full Series Record
    # @return [Fixnum] Returns an unsigned integer, or -1 if the record is invalid
    def seriesid; @hashValues["seriesid"] ? @hashValues["seriesid"].to_i : -1 end

    # The language used for the information included in the current record
    # @return [String] Returns a two digit string indicating the language.
    def language; @hashValues["language"] end

    # The name of the Series
    # @return [String] Returns a string with the series name for the language indicated
    def seriesname; @hashValues["SeriesName"] end

    # Other names of the series than the information returned by {#seriesname}
    # @return [Array<String>] An array of alias names if the series has any other names in that language. Empty if the record does not have any aliases
    def aliasnames; @hashValues["AliasNames"] ? @hashValues["AliasNames"].split('|').reject { |a| a.nil? || a.empty? } : [] end

    # The path to the highest rated banner for this series.
    # @return [String] Returns the relative path to the highest rated banner for this series. Retrieve {#bannerpath_full} get the absolute path.
    def bannerpath_relative; @hashValues["banner"] end

    # A short summary of the series
    # @return [String] Returns the overview for the series
    def overview; @hashValues["Overview"] end

    # The first aired date of the series
    # @return [Date] Returns the first aired date for the series as a Date instance
    # @return [NilClass] Returns nil if the information is not available
    def firstaired; @hashValues["FirstAired"] ? Date.parse(@hashValues["FirstAired"]) : nil end

    # The IMDB id for the series
    # @return [String] Returns the IMDB id for the series if known. Otherwise, nil
    def imdb_id; @hashValues["IMDB_ID"] end

    # The zap2it id for the series
    # @return [String] Returns the zap2it ID if known. Otherwise, nil
    def zap2it_id; @hashValues["zap2it_id"] end

    # The network name on which the series aires
    # @return [String] Returns the Network name if known; Otherwise, nil.
    def network; @hashValues["Network"] end

    # The full path to the banner for the series.
    # @return [URI] The full path for the highest rated banner for the series, returned as a URI instance.
    def bannerpath_full; bannerpath_relative ? URI::join(BASE_URL, "banners/", bannerpath_relative) : nil end

    # Retrieves the Base Series Record for the series
    # @return [TheTvDbParty::BaseSeriesRecord] The Base Series Record for the series
    # @see TheTvDbParty::Client.get_base_series_record
    def get_base_series_record
      client.get_base_series_record seriesid
    end
  end
end
