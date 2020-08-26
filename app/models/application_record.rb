# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :chronological, -> { order(:created_at) }
  scope :reverse_chronological, -> { order(created_at: :desc) }

  def normalize_friendly_id(value)
    CGI.unescapeHTML(Sanitize.clean(value.to_s)).gsub(/'|"/, '').gsub(' & ', ' and ').delete('&').squeeze(' ').parameterize
  end
end
