using System;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api
{
    [XmlType]
    public class SearchSeriesRecord
    {
        private static readonly Uri mirrorPath = new Uri("http://thetvdb.com/api");
        
        [XmlIgnore]
        public TheTvDbClient Client;

        [XmlElement("seriesid")]
        public uint SeriesId { get; set; }

        [XmlElement("language")]
        public string Language { get; set; }

        [XmlElement("SeriesName")]
        public string SeriesName { get; set; }

        [XmlElement("AliasName")]
        public string AliasNameString { get; set; }

        [XmlIgnore]
        public string[] AliasNames
        {
            get { return AliasNameString?.Split(new char[] { '|' }); }
            set { AliasNameString = string.Join("|", value); }
        }

        [XmlElement("banner")]
        public string BannerString { get; set; }

        [XmlIgnore]
        public Uri AbsoluteBannerPath
        {
            get { return new Uri(mirrorPath, BannerString); }
        }

        [XmlIgnore]
        public Uri RelativeBannerPath
        {
            get { return new Uri(BannerString); }
        }

        [XmlElement("Overview")]
        public string Overview { get; set; }

        [XmlElement("FirstAired")]
        public DateTime FirstAired { get; set; }

        [XmlElement("IMDB_ID")]
        public string IMDB_ID { get; set; }

        [XmlElement("zap2it_id")]
        public string Zap2itId { get; set; }

        [XmlElement("Network")]
        public string Network { get; set; }


    }
}
