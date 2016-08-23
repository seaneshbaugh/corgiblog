xml.instruct!
xml.urlset xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url do
    xml.loc root_url
    xml.lastmod Time.now.beginning_of_month.xmlschema
    xml.changefreq 'monthly'
  end
  xml.url do
    if @last_picture.present?
      pictures_lastmod = @last_picture.created_at.xmlschema
    else
      pictures_lastmod = Time.now.beginning_of_month.xmlschema
    end

    xml.loc pictures_url
    xml.lastmod pictures_lastmod
    xml.changefreq 'monthly'
  end
  @pages.each do |page|
    xml.url do
      xml.loc "#{root_url}#{page.slug}"
      xml.lastmod page.updated_at.xmlschema
      xml.changefreq 'monthly'
    end
  end
  xml.url do
    xml.loc contact_url
    xml.lastmod Time.now.beginning_of_month.xmlschema
    xml.changefreq 'monthly'
  end
  @posts.each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.lastmod post.updated_at.xmlschema
      xml.changefreq 'monthly'
    end
  end
end
