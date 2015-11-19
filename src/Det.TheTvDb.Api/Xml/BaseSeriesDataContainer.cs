using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    [XmlRoot("Data")]
    public class BaseSeriesDataContainer
    {
        [XmlElement("Series")]
        public BaseSeriesRecord[] BaseSeriesRecords { get; set; }
    }
}
