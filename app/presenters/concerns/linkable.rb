module Linkable
  extend ActiveSupport::Concern

  def link(options = {})
    link_to @object.title, path, options
  end

  def share_link(options = {})
    link_to '<span class="glyphicon glyphicon-share"</span>'.html_safe, path, options
  end

  def path
    "#{base_path}#{@object.slug}"
  end
end
