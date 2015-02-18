module TheTvDbParty
  # The Base Series Record contains all of the information available about a series. It does not include any banner, season, or episode information.
  class BaseSeriesRecord

    attr_reader :client
    attr_reader :seriesid, :actors, :added, :addedby, :airs_dayofweek, :airs_time, :bannerpath_full, :bannerpath_relative, :contentrating, :fanartpath_full, :fanartpath_relative, :firstaired, :genres, :imdb_id, :language, :lastupdated, :network, :networkid, :overview, :posterpath_full, :posterpath_relative, :rating, :ratingcount, :runtime, :seriesid, :seriesname, :status, :tvcom_id, :zap2it_id

    # @param [TheTvDbParty::Client] client
    # @param [Hash{String => String}] hashValues
    def initialize(client, hashValues)
      @client = client
      @hashValues = hashValues
    end

    # The client instance that retrieved this record
    # @return [TheTvDbParty::Client]
    def client; @client end

    # The identifier that is assigned by TheTvDb to the series
    # @return [Fixnum] An unsigned integer assigned by our site to the series. It does not change and will always represent the same series. Cannot be nil.
    def seriesid; hashValues["id"] ? @hashValues["id"].to_i : -1 end

    # The actors that make up the main cast for the series
    # @return [Array<String>] An array containg the names of actors as string values. Empty if none are listed.
    def actors; hashValues["Actors"] ? @hashValues["Actors"].split('|').reject { |a| a.nil? || a.empty? } : [] end

    # The day of the week the series airs
    # @return [String] The full name in English for the day of the week the series airs in plain text. Can be nil.
    def airs_dayofweek; @hashValues["Airs_DayOfWeek"] end

    # The time of day the series airs on its original network.
    # @return [Time, NilClass] The time of day the series airs on its original network. Can be nil
    # @note The Date portion of the returned value is not relevant
    def airs_time; @hashValues["Airs_Time"] ? Time.parse(@hashValues["Airs_Time"]) : nil end

    # The rating given to the series based on the US rating system
    # @return [String] Can be nil or a 4-5 character string.
    def contentrating; @hashValues["ContentRating"] end

    # The date the series first aired
    # @return [Date, NilClass] The date the series first aired. Can be nil
    def firstaired; @hashValues["FirstAired"] ? Date.parse(hashValues["FirstAired"]) : nil end

    # The Genres of the series
    # @return [Array<String>] A list of genre names. Empty if none are listed
    def genres; @hashValues["Genre"] ? @hashValues["Genre"].split('|').reject { |a| a.nil? || a.empty? } : [] end

    # The IMDB ID for the series.
    # @return [String] An alphanumeric string containing the IMDB ID for the series. Can be nil.
    def imdb_id; @hashValues["IMDB_ID"] end

    # The language of the information that is included in the current record.
    # @return [String] A two character string indicating the language in accordance with ISO-639-1. Cannot be nil.
    def language; @hashValues["Language"] end

    # The network name on which the series airs
    # @return [String] A string containing the network name in plain text. Can be nil.
    def network; @hashValues["Network"] end

    # @return [Fixnum] Not in use, will be an unsigned integer if ever used. Can be nil.
    def networkid; @hashValues["NetworkID"] ? @hashValues["NetworkID"].to_i : -1 end

    # The overview for the series, if possible in the language requested
    # @return [String] A string containing the overview in the language requested. Will return the English overview if no translation is available in the language requested. Can be nil.
    def overview; @hashValues["Overview"] end

    # The average rating our users have rated the series out of 10
    # @return [Float] The average rating our users have rated the series out of 10, rounded to 1 decimal place. 0.0 if no one has rated the series.
    def rating; @hashValues["Rating"] ? @hashValues["Rating"].to_f : 0.0 end

    # The number of users who have rated the series
    # @return [Fixnum] An unsigned integer representing the number of users who have rated the series.
    def ratingcount; @hashValues["RatingCount"] ? @hashValues["RatingCount"].to_i : 0 end

    # The runtime in minutes of an episode of the series.
    # @return [Fixnum] An unsigned integer representing the runtime of the series in minutes. -1 if the information is not available.
    def runtime; @hashValues["Runtime"] ? @hashValues["Runtime"].to_i : -1 end

    # The series id at tv.com
    # @deprecated As TV.com now only uses these ID's internally it's of little use and no longer updated.
    # @return [Fixnum, NilClass] An unsigned integer representing the series ID at tv.com. Can be nil.
    def tvcom_id; @hashValues["SeriesID"] ? @hashValues["SeriesID"].to_i : nil end

    # The name of the series, if possible in the language requested
    # @return [String] A string containing the series name in the language you requested. Will return the English name if no translation is found in the language requested. Can be nil if the name isn't known in the requested language or English.
    def seriesname; @hashValues["SeriesName"] end

    # The status of the series
    # @return [String] A string containing either "Ended" or "Continuing". Can be nil.
    def status; @hashValues["Status"] end

    # The date and time the series was added to the TheTvDb database.
    # @return [DateTime, NilClass] Can be nil for older series
    def added; @hashValues["added"] ? DateTime.parse(@hashValues["added"]) : nil end

    # The user account identifier of the user who added the series to the database
    # @return [Fixnum, NilClass] An unsigned integer. The ID of the user on our site who added the series to our database. Is nil for older series.
    def addedby; @hashValues["addedBy"] ? @hashValues["addedBy"].to_i : nil end

    # The path to the highest rated banner for this series.
    # @return [String] Returns the relative path to the highest rated banner for this series. Retrieve {#bannerpath_full} get the absolute path.
    def bannerpath_relative; @hashValues["banner"] end

    # The path to the highest rated fanart for this series.
    # @return [String] Returns the relative path to the highest rated fanart for this series. Retrieve {#fanartpath_full} get the absolute path.
    def fanartpath_relative; @hashValues["fanart"] end

    # The path to the highest rated poster for this series.
    # @return [String] Returns the relative path to the highest rated poster for this series. Retrieve {#posterpath_full} get the absolute path.
    def posterpath_relative; @hashValues["poster"] end

    # The zap2it id for the series
    # @return [String] An alphanumeric string containing the zap2it id. Can be nil.
    def zap2it_id; @hashValues["zap2it_id"] end

    # The time and date of the last time any changes were made to the series
    # @return [DateTime] An instance containing both time and date of the last update. Can be nil
    def lastupdated; @hashValues["lastupdated"] ? Time.at(@hashValues["lastupdated"].to_i).to_datetime : nil end

    # The full path to the banner for the series.
    # @return [URI] The full path for the highest rated banner for the series, returned as a URI instance.def bannerpath_full; URI::join(BASE_URL, "banners", bannerpath_relative) end

    # The full path to the banner for the series.
    # @return [URI] The full path for the highest rated fanart for the series, returned as a URI instance.
    def fanartpath_full; URI::join(BASE_URL, "banners", fanartpath_relative) end

    # The full path to the banner for the series.
    # @return [URI] The full path for the highest rated poster for the series, returned as a URI instance.
    def posterpath_full; URI::join(BASE_URL, "banners", posterpath_relative) end
  end
end
