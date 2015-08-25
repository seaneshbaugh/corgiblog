# -*- coding: utf-8 -*-
class Post < ActiveRecord::Base
  include OptionsForSelect
  include Slugable

  # Scopes
  scope :alphabetical, -> { order(:title) }

  scope :chronological, -> { order(:created_at) }

  scope :published, -> { where(visible: true) }

  scope :reverse_alphabetical, -> { order('posts.title DESC') }

  scope :reverse_chronological, -> { order('posts.created_at DESC') }

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :user_id

  validates_length_of :title, maximum: 255
  validates_presence_of :title
  validates_uniqueness_of :title

  validates_length_of :body, maximum: 16_777_215

  validates_length_of :style, maximum: 4_194_303

  validates_length_of :meta_description, maximum: 65535

  validates_length_of :meta_keywords, maximum: 65535

  validates_inclusion_of :visible, in: [true, false], message: 'must be true or false'

  validates_associated :user

  # Default Values
  default_value_for :title, ''

  default_value_for :slug, ''

  default_value_for :body, ''

  default_value_for :style, ''

  default_value_for :meta_description, ''

  default_value_for :meta_keywords, ''

  default_value_for :visible, true

  acts_as_taggable

  has_paper_trail

  def published?
    visible
  end

  def self.import_all_from_tumblr
    offset = 0

    begin
      posts = HTTParty.get("http://api.tumblr.com/v2/blog/#{TUMBLR_SETTINGS['blog_url']}/posts/?api_key=#{TUMBLR_SETTINGS['api_key']}&offset=#{offset}&reblog_info=false&notes_info=false")['response']['posts']

      posts.each do |post|
        Post.create_from_tumblr_json post
      end

      offset += 20
    end while posts.present?
  end

  def self.import_from_tumblr(id)
    post = HTTParty.get("http://api.tumblr.com/v2/blog/#{TUMBLR_SETTINGS['blog_url']}/posts/?api_key=#{TUMBLR_SETTINGS['api_key']}&id=#{id}&reblog_info=false&notes_info=false")['response']['posts'][0]

    Post.create_from_tumblr_json post
  end

  def self.create_from_tumblr_json(post)
    title = Tumblr.parse_title_from_hash(post)

    body = Tumblr.parse_body_from_hash(post)

    #case post['type']
    #  when 'text' then
    #    unless post['title'].blank?
    #      #title = post['title'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '\"')
    #      title = Tumblr.sanitize_title(post['title'])
    #    end
    #
    #    unless post['body'].blank?
    #      body = post['body'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')
    #    end
    #
    #  when 'quote' then
    #    unless post['text'].blank?
    #      #title = post['text'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '\"').truncate(48)
    #      title = Tumblr.sanitize_title(post['text'])
    #    end
    #
    #    unless post['text'].blank?
    #      body = "<p><strong>#{post['text'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}</strong></p>"
    #
    #      unless post['source'].blank?
    #        body += "<p>&mdash; #{post['source']}</p>"
    #      end
    #    end
    #
    #  when 'link' then
    #    unless post['title'].blank?
    #      #title = post['title'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '\"')
    #      title = Tumblr.sanitize_title(post['title'])
    #    end
    #
    #    unless post['url'].blank?
    #      if post['title'].present?
    #        body = "<a href=\"#{post['url']}\">#{post['title']}</a>"
    #      else
    #        body = "<a href=\"#{post['url']}\">#{post['url']}</a>"
    #      end
    #    end
    #
    #    unless post['description'].blank?
    #      body += post['description'].gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')
    #    end
    #
    #  when 'answer' then
    #    unless post['question'].blank?
    #      #title = ActionController::Base.helpers.strip_tags(post['question'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')).truncate(48)
    #      title = Tumblr.sanitize_title(post['question'])
    #    end
    #
    #    unless post['question'].blank? || post['asking_name'].blank? || post['answer'].blank?
    #      body = "<p><strong><a href=\"#{post['asking_url']}\">#{post['asking_name']}</a> asked: #{post['question'].gsub(/’|&#8217;/, '\'')}</strong></p>#{post['answer'].gsub(/’|&#8217;/, '\'')}"
    #    end
    #
    #  when 'video' then
    #    unless post['caption'].blank?
    #      #title = ActionController::Base.helpers.strip_tags(post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')).truncate(48)
    #      title = Tumblr.sanitize_title(post['caption'])
    #    end
    #
    #    unless post['player'].blank?
    #      body = "#{post['player']}"
    #
    #      unless post['caption'].blank?
    #        body +="#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}"
    #      end
    #    end
    #
    #  when 'audio' then
    #    unless post['caption'].blank?
    #      #title = ActionController::Base.helpers.strip_tags(post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')).truncate(48)
    #      title = Tumblr.sanitize_title(post['caption'])
    #    end
    #
    #    unless post['player'].blank?
    #      post['player'].each do |song|
    #        body += "<div class='tumblr-audio'#{song['embed_code']}</div>"
    #      end
    #
    #      unless post['caption'].blank?
    #        body += "#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '&quot;')}"
    #      end
    #    end
    #
    #  when 'photo' then
    #    unless post['caption'].blank?
    #      #title = ActionController::Base.helpers.strip_tags(post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')).truncate(48)
    #      title = Tumblr.sanitize_title(post['caption'])
    #    end
    #
    #    unless post['photos'].blank?
    #      post['photos'].each do |photo|
    #        if photo['caption'].present?
    #          photo_alt_text = photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')
    #          photo_title_text = photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '&quot;')
    #        else
    #          photo_alt_text = 'Cross Posted from Tumblr'
    #          photo_title_text = 'Cross Posted from Tumblr'
    #        end
    #
    #        body += "<p class=\"center\"><img src=\"#{photo['original_size']['url']}\" alt=\"#{photo_alt_text}\" title=\"#{photo_title_text}\" /></p>"
    #
    #        unless photo['caption'].blank?
    #          body += "<p class=\"center\">#{photo['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\"')}</p>"
    #        end
    #      end
    #    end
    #
    #    unless post['caption'].blank?
    #      body += "<p class=\"center\">#{post['caption'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”/, '\""')}</p>"
    #    end
    #
    #  when 'chat' then
    #    unless post['title'].blank?
    #      #title = post['title'].gsub(/\s+/, ' ').gsub(/’|&#8217;/, '\'').gsub(/“|”|\"/, '\"')
    #      title = Tumblr.sanitize_title(post['title'])
    #    end
    #
    #    unless post['dialog'].blank?
    #      body += "<li>"
    #
    #      post['dialog'].each do |message|
    #        unless message['label'].blank?
    #          unless message['phrase'].blank?
    #            body += "<li><strong>#{message['label']}</strong> #{message['phrase']}</li>"
    #          end
    #        end
    #      end
    #
    #      body += "</li>"
    #    end
    #  else
    #end
    #
    #if title.blank?
    #  title = "Tumblr Post from #{post['date']}"
    #end

    t = title
    n = 1

    duplicate = nil

    begin
      duplicate = Post.where('`posts`.`title` = ? AND `posts`.`tumblr_id` != ?', t, post['id']).first

      unless duplicate.nil?
        t = title + " #{n}"
        n += 1
      end
    end while !duplicate.nil?

    title = t

    style = ''

    meta_description = ''

    if post['tags'].present?
      meta_keywords = post['tags'].join(', ')
    else
      meta_keywords = ''
    end

    user_id = User.where(:role => 'sysadmin').first.id

    tumblr_id = post['id'].to_s

    if post['date'].present?
      created_at = updated_at = DateTime.parse(post['date'])
    else
      created_at = updated_at = Time.now
    end

    new_post = Post.new

    new_post.title = title
    new_post.body = body
    new_post.style = style
    new_post.meta_description = meta_description
    new_post.meta_keywords = meta_keywords
    new_post.user_id = user_id
    new_post.tumblr_id = tumblr_id
    new_post.created_at = created_at
    new_post.updated_at = updated_at

    new_post.save
  end

  def more
    if body.include?('<!--more-->')
      body[0..body.index('<!--more-->') - 1]
    else
      body
    end
  end

  def truncated?
    body.length > more.length
  end

  def first_image
    images = Nokogiri::HTML(body).xpath('//img')

    if images.length > 0
      images[0]['src']
    else
      nil
    end
  end
end
