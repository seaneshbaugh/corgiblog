module Admin::AdminHelper
  def picture_inserter(target)
    render :partial => 'shared/admin/picture_inserter', :locals => { :target => target }
  end

  def get_gem_dependencies
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

    lockfile.specs.map { |spec| { :name => spec.name, :version => spec.version.version, :dependencies => spec.dependencies.map { |dependency| { :name => dependency.name, :requirement => dependency.requirement } } } }
  end
end
