using System;
using System.Net;
using System.Xml.Serialization;
using Det.TheTvDb.Api.Xml;

namespace Det.TheTvDb.Api
{
    public class TheTvDbClient
    {
        public string ApiKey = null;
        public string Language = "en";
        public TheTvDbClient()
        {
        }

        public TheTvDbClient(string apiKey = null, string language = "en")
        {
            ApiKey = apiKey;
            Language = language;
        }

        public SearchSeriesDataContainer GetSeries(string seriesName)
        {
            var uriBuilder = new UriBuilder();
            uriBuilder.Scheme = "http";
            uriBuilder.Host = "thetvdb.com";
            uriBuilder.Path = "GetSeries.php";
            uriBuilder.Query = "seriesname=" + seriesName;
            uriBuilder.Query += "language=" + Language;

            SearchSeriesDataContainer series = null;

            try
            {
                var req = WebRequest.Create(uriBuilder.ToString()) as HttpWebRequest;

                var xmlSerializer = new XmlSerializer(typeof(SearchSeriesDataContainer));

                using (var resp = req.GetResponseAsync().Result)
                {
                    series = xmlSerializer.Deserialize(resp.GetResponseStream()) 
                    as SearchSeriesDataContainer;
                }
            }
            catch { }
            
            return series;
        }
        
        public BaseSeriesDataContainer GetBaseSeriesRecord(string seriesid)
        {
            
        }
    }
}
