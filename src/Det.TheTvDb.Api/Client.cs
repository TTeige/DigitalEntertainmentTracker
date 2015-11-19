using System;
using System.Net;
using System.Xml;

namespace Det.TheTvDb.Api
{
    public class Client
    {
        public string ApiKey = null;
        public string Language = "en";   
        public Client()
        {
        }
        
        public Client(string apiKey = null)
        {
            ApiKey = apiKey;
        }
        
        public SearchSeriesRecord GetSeries(string seriesName) 
        {
            var uriBuilder = new UriBuilder();
            uriBuilder.Scheme = "http";
            uriBuilder.Host = "thetvdb.com";
            uriBuilder.Path = "GetSeries.php";
            uriBuilder.Query = seriesName;
            var req = WebRequest.Create(uriBuilder.ToString()) as HttpWebRequest;
            
            var resp = req.GetResponse();
            
            
            
            return new SearchSeriesRecord();
        }
    }
}
