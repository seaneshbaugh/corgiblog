# frozen_string_literal: true

module Admin
  module AdminHelper
    def creatable_models
      @creatable_models ||= [Post, Page, Picture, User].select do |model|
        policy([:admin, model]).create?
      end
    end

    def cancel_icon(options = {})
      content_tag(:i, 'clear', class: classnames('material-icons', options[:class]))
    end

    def cancel_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: warning_button_class) do
        label = options[:label].to_s if options[:label]

        cancel_icon(class: { 'left' => label }) + label
      end
    end

    def caution_button_class
      'btn btn-flat waves-effect waves-light yellow darken-3'
    end

    def delete_icon(options = {})
      content_tag(:i, 'delete_forever', class: classnames('material-icons', options[:class]))
    end

    def delete_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: warning_button_class, rel: 'nofollow', method: :delete, data: { confirm: t('confirm_delete') }) do
        label = options[:label].to_s if options[:label]

        delete_icon(class: { 'left' => label })+ label
      end
    end

    def edit_icon(options = {})
      content_tag(:i, 'edit', class: classnames('material-icons', options[:class]))
    end

    def edit_icon_link(url_or_path, options = {})
      link_to(url_or_path, class: success_button_class) do
        label = options[:label].to_s if options[:label]

        edit_icon(class: { 'left' => label }) + label
      end
    end

    def gem_dependencies
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

      lockfile.specs.map do |spec|
        {
          name: spec.name,
          version: spec.version.version,
          dependencies: spec.dependencies.map { |dependency| { name: dependency.name, requirement: dependency.requirement } }
        }
      end
    end

    def git_repo
      @git_repo ||= Git.open(Rails.root)
    end

    def git_branch
      git_repo.current_branch
    end

    def git_commit_sha
      git_repo.log.first.sha
    end

    def info_button_class
      'btn btn-flat waves-effect waves-light blue darken-3'
    end

    def quick_links_column_width
      @quick_links_column_width ||= 12 / creatable_models.length
    end

    def search_icon(options = {})
      content_tag(:i, 'search', class: classnames('material-icons', options[:class]))
    end

    def success_button_class
      'btn btn-flat waves-effect waves-light green darken-3'
    end

    def warning_button_class
      'btn btn-flat waves-effect waves-light red darken-3'
    end
  end
end
