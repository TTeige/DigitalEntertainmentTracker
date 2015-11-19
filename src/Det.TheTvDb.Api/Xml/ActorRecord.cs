using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    public class ActorRecord
    {
        private static readonly Uri mirrorPath = new Uri("http://thetvdb.com/api/banners");
        
        [XmlElement("id")]
        public uint Id { get; set; }
        
        [XmlElement("Image")]
        public string ImageString { get; set; }
        
        [XmlIgnore]
        public Uri AbsoluteImagePath
        {
            get { return new Uri(mirrorPath, ImageString); }
        }

        [XmlIgnore]
        public Uri RelativeImagePath
        {
            get { return new Uri(ImageString); }
        }
        
        [XmlElement("Name")]
        public string Name { get; set; }
        
        [XmlElement("Role")]
        public string Role { get; set; }
        
        [XmlElement("SortOrder")]
        public uint SortOrder { get; set; }
    }
}
