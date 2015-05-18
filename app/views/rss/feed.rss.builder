xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Upcoming Episodes"
    newline = "\n"
    for episode in @upcoming
      xml.item do
        xml.link url_for :only_path => false, :controller => 'series', :action => 'show', :seriesid => episode[3]
        xml.title episode[0] + " - " + episode[2]
        xml.pubDate episode[1]
       xml.description "<img src='#{episode[5].to_s}' alt=''/> <br/> <strong/>  #{"Season:"} #{episode[7]}  #{"  Episode:"} #{episode[6]} </strong> <br/>#{episode[4]} "   end
    end
  end
end