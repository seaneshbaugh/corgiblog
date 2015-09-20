module Admin
  module AdminHelper
    def gem_dependencies
      lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

      lockfile.specs.map do |spec|
        {
          name: spec.name,
          version: spec.version.version,
          dependencies: spec.dependencies.map do |dependency|
            {
              name: dependency.name,
              requirement: dependency.requirement
            }
          end
        }
      end
    end

    def icon_delete_link(url_or_path)
      link_to('<span class="glyphicon glyphicon-remove"></span>'.html_safe, url_or_path, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-mini', rel: 'tooltip', title: 'Delete')
    end

    def icon_edit_link(url_or_path)
      link_to('<span class="glyphicon glyphicon-edit"></span>'.html_safe, url_or_path, class: 'btn btn-mini', rel: 'tooltip', title: 'Edit')
    end
  end
end
