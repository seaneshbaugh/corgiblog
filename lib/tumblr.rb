module Tumblr
  def self.sanitize_title(title)
    ActionController::Base.helpers.strip_tags(title).gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '\"').truncate(48)
  end

  def self.parse_title_from_hash(post)
    title = ''

    case post['type']
      when 'text' then
        unless post['title'].blank?
          title = Tumblr.sanitize_title(post['title'])
        end
      when 'quote' then
        unless post['text'].blank?
          title = Tumblr.sanitize_title(post['text'])
        end
      when 'link' then
        unless post['title'].blank?
          title = Tumblr.sanitize_title(post['title'])
        end
      when 'answer' then
        unless post['question'].blank?
          title = Tumblr.sanitize_title(post['question'])
        end
      when 'video' then
        unless post['caption'].blank?
          title = Tumblr.sanitize_title(post['caption'])
        end
      when 'audio' then
        unless post['caption'].blank?
          title = Tumblr.sanitize_title(post['caption'])
        end
      when 'photo' then
        unless post['caption'].blank?
          title = Tumblr.sanitize_title(post['caption'])
        end
      when 'chat' then
        unless post['title'].blank?
          title = Tumblr.sanitize_title(post['title'])
        end
      else
    end

    if title.blank?
      title = "Tumblr Post from #{post['date']}"
    end

    title
  end

  def self.parse_body_from_hash(post)
    body = ''

    case post['type']
      when 'text' then
        unless post['body'].blank?
          body = post['body'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')
        end
      when 'quote' then
        unless post['text'].blank?
          body = "<p><strong>#{post['text'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}</strong></p>"

          unless post['source'].blank?
            body += "<p>&mdash; #{post['source']}</p>"
          end
        end
      when 'link' then
        unless post['url'].blank?
          if post['title'].present?
            body = "<a href=\"#{post['url']}\">#{post['title']}</a>"
          else
            body = "<a href=\"#{post['url']}\">#{post['url']}</a>"
          end
        end

        unless post['description'].blank?
          body += post['description'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')
        end
      when 'answer' then
        unless post['question'].blank? || post['asking_name'].blank? || post['answer'].blank?
          body = "<p><strong><a href=\"#{post['asking_url']}\">#{post['asking_name']}</a> asked: #{post['question'].gsub(/’|&#8217;/, '\'')}</strong></p>#{post['answer'].gsub(/’|&#8217;/, '\'')}"
        end
      when 'video' then
        unless post['player'].blank?
          post['player'].each do |video|
            body += video['embed_code']
          end

          unless post['caption'].blank?
            body +="#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}"
          end
        end
      when 'audio' then
        unless post['player'].blank?
          post['player'].each do |song|
            body += "<div class='tumblr-audio'#{song['embed_code']}</div>"
          end

          unless post['caption'].blank?
            body += "#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}"
          end
        end
      when 'photo' then
        unless post['photos'].blank?
          post['photos'].each do |photo|
            if photo['caption'].present?
              photo_alt_text = photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')
              photo_title_text = photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')
            else
              photo_alt_text = 'Cross Posted from Tumblr'
              photo_title_text = 'Cross Posted from Tumblr'
            end

            body += "<p class=\"center\"><img src=\"#{photo['original_size']['url']}\" alt=\"#{photo_alt_text}\" title=\"#{photo_title_text}\" /></p>"

            unless photo['caption'].blank?
              body += "<p class=\"center\">#{photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')}</p>"
            end
          end
        end

        unless post['caption'].blank?
          body += "<p class=\"center\">#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\""')}</p>"
        end
      when 'chat' then
        unless post['dialog'].blank?
          body += "<li>"

          post['dialog'].each do |message|
            unless message['label'].blank?
              unless message['phrase'].blank?
                body += "<li><strong>#{message['label']}</strong> #{message['phrase']}</li>"
              end
            end
          end

          body += "</li>"
        end
      else
    end

    body
  end
end
