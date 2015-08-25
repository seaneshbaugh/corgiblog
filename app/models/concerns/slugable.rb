module Slugable
  extend ActiveSupport::Concern

  included do
    validates_exclusion_of :slug, in: %w(contact create destroy edit new index page pages picture pictures post posts show update user users), message: 'cannot be %{value}.'
    validates_length_of :slug, maximum: 255, allow_blank: true
    validates_presence_of :slug
    validates_uniqueness_of :slug

    before_validation :generate_slug
  end

  def to_param
    slug
  end

  protected

  def generate_slug
    if title.blank?
      self.slug = id.to_s
    else
      self.slug = CGI.unescapeHTML(Sanitize.clean(title)).gsub(/'|"/, '').gsub(' & ', 'and').gsub('&', '').squeeze(' ').parameterize
    end
  end
end
