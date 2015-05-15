xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Upcoming Series"

    for episode in @upcoming
           xml.image do
       xml.title          "lucashills.com"
       xml.url            "https://pbs.twimg.com/profile_images/960696059/PIC_logo.jpg"
       xml.link           "lucashills.com"
       xml.width          "80"
       xml.height         "37"
       xml.description    "Random programming tips, notes and news I thought worth sharing"
   end

      xml.item do


      xml.link url_for :only_path => false, :controller => 'series', :action => 'show', :seriesid => episode[3]
      xml.title episode[0] + " - " + episode[2]
      xml.pubDate episode[1]
      xml.description episode[4]

 
      
      end
    end
  end
end





