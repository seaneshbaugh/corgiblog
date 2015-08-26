class PostPresenter < BasePresenter
  include FrontEnd
  include Linkable

  delegate :content_tag, to: :@template
  delegate :params, to: :@template

  def initialize(post, template)
    super

    @post = post
  end

  def by
    "by #{@post.user.first_name}"
  end

  def created_at(format = nil)
    return unless @post.created_at

    if format
      @post.created_at.strftime(format)
    else
      super()
    end
  end

  def date
    day = content_tag('div', class: 'day') do
      @post.created_at.strftime('%d')
    end

    month = content_tag('div', class: 'month') do
      @post.created_at.strftime('%b')
    end

    year = content_tag('div', class: 'year') do
      @post.created_at.strftime('%Y')
    end

    (day + month + year).html_safe
  end

  def first_image
    images = Nokogiri::HTML(@post.body).xpath('//img')

    images[0]['src'] if images.length > 0
  end

  def metadata
    "by #{@post.user.first_name} on #{@post.created_at.strftime("%B #{@post.created_at.day.ordinalize}, %Y")}"
  end

  def more
    if params[:action] == 'index' && truncated?
      body_content = @post.body[0..@post.body.index('<!--more-->') - 1]

      body_content_class = 'body-content truncated'

      body_content_tag = content_tag(:div, body_content.html_safe, class: body_content_class)

      body_content_tag + more_link
    else
      body_tag
    end
  end

  def more_link
    return unless truncated?

    content_tag(:div, link_to('Read More', @post), class: 'read-more')
  end

  def tag_links
    @post.tag_list.map { |tag| link_to tag, root_path(tag: tag) }.join(', ').html_safe
  end

  def title_text
    "\"#{@post.title}\" posted on #{@post.created_at.strftime('%Y-%m-%d %H:%M:%S')}"
  end

  def truncated?
    @post.body.include?('<!--more-->')
  end

  def tumblr_link
    return unless @post.tumblr_id.present?

    link_to 'Originally posted by Casie on Tumblr', "http://conneythecorgi.tumblr.com/#{@post.tumblr_id}"
  end

  def updated_at(format = nil)
    return unless @post.updated_at

    if format
      @post.updated_at.strftime(format)
    else
      super()
    end
  end

  def user_full_name
    @post.user.full_name
  end

  private

  def base_path
    '/posts/'
  end
end
