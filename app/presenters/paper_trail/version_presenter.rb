module PaperTrail
  class VersionPresenter < BasePresenter
    include Linkable

    def initialize(version, template)
      super

      @version = version
    end

    path_and_url_links(:item) do |path_or_url, args|
      display_method = args.first[:display_method] if args.present?

      link_to @version.item.send(display_method || object_presenter.display_method), path_or_url_for(path_or_url, "admin_#{@version.item.class.name.downcase}".to_sym, @version.item) if @version.item
    end

    path_and_url_links(:whodunnit) do |path_or_url|
      link_to whodunnit.full_name, path_or_url_for(path_or_url, :admin_user, whodunnit) if whodunnit
    end

    def changeset
      return @version.changeset if @version.changeset.present?

      if @version.event == 'destroy'
        @changeset ||= reified_object.attributes.reject { |_, attribute_value| attribute_value.blank? }.each_with_object({}) do |(attribute_name, attribute_value), changes|
          changes[attribute_name] = [attribute_value, '']
        end
      end
    end

    def dasherized_attribute_name(attribute)
      attribute.to_s.parameterize.dasherize if reified_object.respond_to?(attribute)
    end

    def dasherized_item_type
      @dasherized_item_type ||= @version.item_type.underscore.parameterize.dasherize
    end

    def item_type
      @item_type ||= @version.item_type.constantize
    end

    def item_type_human_attribute_name(attribute)
      item_type.human_attribute_name(attribute)
    end

    def reified_object
      @reified_object ||= @version.reify
    end

    def whodunnit
      @whodunnit ||= User.where(id: @version.whodunnit).first
    end

    private

    def object_presenter
      @object_presenter ||= "#{@version.item_type}Presenter".constantize
    end
  end
end
