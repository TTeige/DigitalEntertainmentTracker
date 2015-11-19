using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    [XmlRoot("Banners")]
    public class BannersDataContainer
    {
        [XmlElement("Banner")]
        public BannerRecord[] Banners;
    }
}
