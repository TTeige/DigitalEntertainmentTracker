xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Series"
    xml.description "Upcomming"

    for episode in @upcoming
      xml.item do
        xml.title episode[0]
        xml.episodeTitle episode[2]
        xml.airDate episode[1]
      end
    end
  end
end