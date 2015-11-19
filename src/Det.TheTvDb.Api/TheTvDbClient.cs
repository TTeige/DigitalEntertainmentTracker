using System;
using System.Net;
using System.Xml;
using System.Xml.Serialization;

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
        
        public SearchSeriesRecord GetSeries(string seriesName, string language = "en") 
        {
            var uriBuilder = new UriBuilder();
            uriBuilder.Scheme = "http";
            uriBuilder.Host = "thetvdb.com";
            uriBuilder.Path = "GetSeries.php";
            uriBuilder.Query = "seriesname=" + seriesName;
            uriBuilder.Query += "language=" + language;
            
            SearchSeriesRecord searchRecord;
            
            try 
            {
                var req = WebRequest.Create(uriBuilder.ToString()) as HttpWebRequest;
                
                var resp = req.GetResponseAsync();
                
                var xmlSerializer = new XmlSerializer();
                
                
            }
            
            
            
            
            return searchRecord;
        }
    }
}
