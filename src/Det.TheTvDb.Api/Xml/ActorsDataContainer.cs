using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Det.TheTvDb.Api.Xml
{
    [XmlRoot("Actors")]
    public class ActorsDataContainer
    {
        [XmlElement("Actor")]
        public ActorRecord[] Actors;
    }
}
