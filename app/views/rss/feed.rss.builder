#encoding UTF-8

xml.instruct! :xml, version => "1.0"
xml.rss :version => "2.0" do
	xml.title "Series"
	xml.description "Upcoming Series"

	for episode in @upcoming 
		xml.item do
			xml.title episode[0]
		end
	end
end
