module Admin::AdminHelper
  def insert_picture_button(target)
    render :partial => 'shared/insert_picture_button', :locals => { :target => target }
  end

  def get_gem_dependencies
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(Rails.root.join('Gemfile.lock')))

    lockfile.specs.map { |spec| { :name => spec.name, :version => spec.version.version, :dependencies => spec.dependencies.map { |dependency| { :name => dependency.name, :requirement => dependency.requirement } } } }
  end
end
