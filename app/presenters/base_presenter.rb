class BasePresenter
  attr_reader :object, :template

  delegate :l, to: :@template
  delegate :link_to, to: :@template
  delegate :t, to: :@template

  def self.display_method
    :id
  end

  def initialize(object, template)
    @object = object

    @template = template
  end

  def method_missing(method, *args, &block)
    @object.send(method, *args, &block)
  rescue NoMethodError
    super
  end

  def created_at
    if @object.respond_to?(:created_at) && @object.created_at.present?
      l(@object.created_at)
    else
      t('na')
    end
  end

  def updated_at
    if @object.respond_to?(:updated_at) && @object.updated_at.present?
      l(@object.updated_at)
    else
      t('na')
    end
  end
end
