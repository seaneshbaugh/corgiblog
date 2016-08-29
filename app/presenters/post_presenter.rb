class PostPresenter < BasePresenter
  include FrontEnd
  include Linkable

  def self.display_method
    :title
  end

  def self.version_display_attributes
    [
      {
        method: :title,
        header_class: 'col-xs-5'
      },
      {
        method: :user_link,
        header_class: 'col-xs-2'
      }
    ]
  end

  def initialize(post, template)
    super

    @post = post
  end

  def by
    t('posts.show.by', name: @post.user.first_name)
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
    t('posts.show.metadata', name: @post.user.first_name, date: @post.created_at.strftime("%B #{@post.created_at.day.ordinalize}, %Y"))
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

    content_tag(:div, link_to(t('posts.index.read_more'), @post), class: 'read-more')
  end

  def tag_links
    @post.tags.map { |tag| link_to(tag.name, @template.root_path(tag: tag.name)) }.join(', ').html_safe
  end

  def title_text
    t('posts.show.title_text', title: @post.title, time: l(@post.created_at))
  end

  def truncated?
    @post.body.include?('<!--more-->')
  end

  def tumblr_link(text = nil)
    return unless @post.tumblr_id.present?

    text = @post.tumblr_id if text.blank?

    link_to(text, "http://#{ENV['TUMBLR_BLOG_URI']}/#{@post.tumblr_id}")
  end

  def user_full_name
    @post.user.full_name
  end

  def user_link
    link_to(user_full_name, @template.admin_user_path(@post.user))
  end

  def visible
    if @post.visible
      t('yes')
    else
      t('no')
    end
  end

  def sticky
    if @post.sticky
      t('yes')
    else
      t('no')
    end
  end

  private

  def base_path
    '/posts/'
  end
end
