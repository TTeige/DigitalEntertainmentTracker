using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    [XmlType]
    public class BannerRecord
    {
        private static readonly Uri mirrorPath = new Uri("http://thetvdb.com/api/banners");
        
        [XmlElement("BannerPath")]
        public string BannerPathString { get; set; }

        [XmlIgnore]
        public Uri AbsoluteBannerPath
        {
            get { return new Uri(mirrorPath, BannerPathString); }
        }

        [XmlIgnore]
        public Uri RelativeBannerPath
        {
            get { return new Uri(BannerPathString); }
        }
        
        [XmlElement("BannerType")]
        public string BannerType { get; set; }
        
        [XmlElement("BannerType2")]
        public string BannerType2 { get; set; }
        
        [XmlElement("Language")]
        public string Language { get; set; }
        
        [XmlElement("Season")]
        public uint Season { get; set; }
        
        [XmlElement("Rating")]
        public double? Rating { get; set; }
        
        [XmlElement("RatingCount")]
        public uint RatingCount { get; set; }
        
        [XmlElement("SeriesName")]
        public bool SeriesName { get; set; }
        
    }
}
