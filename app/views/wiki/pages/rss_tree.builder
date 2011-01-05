xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Subtree of " + @page.title + " changes"
    xml.description "Recent changes for subtree of wiki page " + @page.title
    xml.link root_url.chomp('/') + (@page.path.nil? ?  '':  '/' +@page.path), ''

       @revisions.each do |revision|
        xml.item do
          summary = revision.summary.to_s
          xml.title "#{revision.author_full_name} (#{revision.author_username}) edited #{revision.pg_part_name} #{summary} of #{revision.pg_name}"
          #TODO solve datetime conversion          xml.pubDate (revision.created_at.to_s(:rfc822))
          xml.pubDate revision.created_at.to_s
          xml.link root_url.chomp('/') +  ((revision.number.to_i > 1) ? (diff_wiki_page_path(@page) + '?revisions[]=' + (revision.number).to_s + '&revisions[]=' + (revision.number.to_i - 1).to_s()) : (@page.path.nil? ?  '':  '/' +@page.path)),''
        end
        end
      end
    end
