class PicturePresenter < BasePresenter
  delegate :image_tag, to: :@template

  def initialize(picture, template)
    super

    @picture = picture
  end

  def medium_image
    image_tag @picture.image.url(:medium), alt: @picture.alt_text, class: 'medium', style: 'max-height: 300px;', title: @picture.title
  end

  def original_image
    image_tag @picture.image.url, alt: @picture.alt_text, class: 'original', title: @picture.title
  end

  def thumbnail_image
    image_tag @picture.image.url(:thumb), alt: @picture.alt_text, class: 'thumb', style: 'max-height: 50px;', title: @picture.title
  end
end
