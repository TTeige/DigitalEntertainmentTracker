using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    [XmlRoot("Data")]
    public class SearchSeriesDataContainer
    {
        [XmlElement("Series")]
        public SearchSeriesRecord[] SeriesRecords { get; set; }
    }
}
