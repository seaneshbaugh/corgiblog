class PostPresenter < BasePresenter
  include FrontEnd
  include Linkable

  delegate :content_tag, to: :@template
  delegate :params, to: :@template

  def initialize(post, template)
    super

    @post = post
  end

  def created_at(format = nil)
    return unless @post.created_at

    if format
      @post.created_at.strftime(format)
    else
      super
    end
  end

  def first_image
    images = Nokogiri::HTML(@post.body).xpath('//img')

    images[0]['src'] if images.length > 0
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

  def truncated?
    @post.body.include?('<!--more-->')
  end

  def updated_at(format = nil)
    return unless @post.updated_at

    if format
      @post.updated_at.strftime(format)
    else
      super
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
