module TheTvDbParty
  # The ThTvDb API client
  class Client
    include HTTParty

    attr_accessor :apikey, :language

    @language = nil

    # Creates a new TheTvDb client with the given API key
    # @param [String] apikey The API key to use when accessing the ThTvDb programmers API
    # @note If nil is specified for _apikey_, the client will not be able to access the API successfully for most functions
    #       The {#search} method will always be available, even if you do not have a valid API key.
    def initialize(apikey)
      @apikey = apikey
    end

    # Accesses the API key currently used by the client
    # @return [String] The API key that is currently in use
    def apikey; @apikey end
    # @param [String] value The new API key to use
    # @return [String] The new value
    def apikey=(value) @apikey = value end

    # Accesses the language currently used by the client when accessing the TheTvDb API.
    # @return [String] A two-letter string value indicating the language used. May also be 'all' if all availabe translations are retrieved from TheTvDb
    # @return [NilClass] nil if the default language (english) should be used.
    def language; @language end
    # @param [String, NilClass] value A two-letter string value indicating the language used. May also be 'all' if all availabe translations are retrieved from TheTvDb. The may also be nil if the language does not need to be specified explicitly.
    # @return [String] The new value
    def language=(value) @language = value end

    # This interface allows you to find the id of a series based on its name.
    # @param [String] seriesname This is the string you want to search for. If there is an exact match for the parameter, it will be the first result returned.
    # @return [Array<TheTvDbParty::SearchSeriesRecord>] An array of records that represent the search results.
    # @see http://thetvdb.com/wiki/index.php?title=API:GetSeries
    # @note The method call with the account identifier is currently not supported.
    # @see #search
    def get_series(seriesname) search seriesname end

    # This interface allows you to find the id of a series based on its name.
    # @param [String] seriesname This is the string you want to search for. If there is an exact match for the parameter, it will be the first result returned.
    # @return [Array<TheTvDbParty::SearchSeriesRecord>] An array of records that represent the search results.
    # @see http://thetvdb.com/wiki/index.php?title=API:GetSeries
    # @note The method call with the account identifier is currently not supported.
    def search(seriesname)
      http_query = { :seriesname => seriesname }
      http_query[:language => @language] if @language
      response = self.class.get(URI::join(BASE_URL, 'api/', 'GetSeries.php'), { :query => http_query }).parsed_response
      return [] unless response["Data"]
      case response["Data"]["Series"]
        when Array
          response["Data"]["Series"].map {|s|SearchSeriesRecord.new(self, s)}
        when Hash
          [SearchSeriesRecord.new(self, response["Data"]["Series"])]
        else
          []
      end
    end

    # Retrieves the Base Series Record for a given series by its series id.
    # @param [String, Fixnum] seriesid The TheTvDb assigned unique identifier for the series to access.
    # @return [TheTvDbParty::BaseSeriesRecord] A base series record instance or nil if the series could not be found.
    def get_base_series_record(seriesid, language = nil)
      unless @language
        request_url = "#{@apikey}/series/#{seriesid}"
      else
        request_url = "#{@apikey}/series/#{seriesid}/#{@language}.xml"
      end
      request_url = URI.join(BASE_URL, 'api/', request_url)
      resp = self.class.get(request_url).parsed_response
      return nil unless resp["Data"]["Series"]
      BaseSeriesRecord.new(self, resp["Data"]["Series"])
    end
  end
end

