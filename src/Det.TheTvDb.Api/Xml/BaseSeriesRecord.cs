using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api
{
    [XmlType]
    public class BaseSeriesRecord
    {
        private static readonly Uri mirrorPath = new Uri("http://thetvdb.com/api");

        [XmlElement("seriesid")]
        public uint SeriesId { get; set; }

        [XmlElement("Actors")]
        public string ActorsString { get; set; }

        [XmlIgnore]
        public string[] Actors
        {
            get { return ActorsString?.Split(new char[] { '|' }); }
            set { ActorsString = string.Join("|", value); }
        }

        [XmlElement("Airs_DayOfWeek")]
        public string AirsDayOfWeek { get; set; }

        [XmlElement("Airs_Time")]
        public string AirsTime { get; set; }

        [XmlElement("ContentRating")]
        public string ContentRating { get; set; }

        [XmlElement("FirstAired")]
        public DateTime FirstAired { get; set; }

        [XmlElement("Genre")]
        public string GenreString { get; set; }

        [XmlIgnore]
        public string[] Genre
        {

            get { return GenreString?.Split(new char[] { '|' }); }
            set { ActorsString = string.Join("|", value); }
        }

        [XmlElement("IMDB_ID")]
        public string IMDB_ID { get; set; }

        [XmlElement("Language")]
        public string Language { get; set; }

        [XmlElement("Network")]
        public string Network { get; set; }

        [XmlElement("NetworkID")]
        public uint NetworkID { get; set; }

        [XmlElement("Rating")]
        public float Rating { get; set; }

        [XmlElement("RatingCount")]
        public uint RatingCount { get; set; }

        [XmlElement("Runtime")]
        public uint Runtime { get; set; }

        [XmlElement("SeriesID")]
        public uint SeriesID { get; set; }

        [XmlElement("SeriesName")]
        public string SeriesName { get; set; }

        [XmlElement("Status")]
        public string Status { get; set; }

        [XmlElement("added")]
        public DateTime Added { get; set; }

        [XmlElement("addedBy")]
        public string AddedBy { get; set; }

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

        [XmlElement("fanart")]
        public string FanartString { get; set; }

        [XmlIgnore]
        public Uri AbsoluteFanartPath
        {
            get { return new Uri(mirrorPath, FanartString); }
        }

        [XmlIgnore]
        public Uri RelativeFanartPath
        {
            get { return new Uri(FanartString); }
        }

        [XmlElement("lastupdated")]
        public string LastUpdated { get; set; }

        [XmlElement("posters")]
        public string PosterString { get; set; }

        [XmlIgnore]
        public Uri AbsolutePosterPath
        {
            get { return new Uri(mirrorPath, PosterString); }
        }

        [XmlIgnore]
        public Uri RelativePosterPath
        {
            get { return new Uri(PosterString); }
        }

        [XmlElement("zap2it_id")]
        public string Zap2itId { get; set; }
    }
}
