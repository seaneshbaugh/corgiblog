module TumblrTestHelper
  def self.included(_)
    @@tumblr_json_fixtures = %i(answer audio chat link photo quote text video).each_with_object({}) do |type, memo|
      memo[type] = JSON.parse(File.read(Rails.root.join('test', 'fixtures', 'tumblr', "#{type}s.json")))
    end
  end

  def tumblr_json(type, id)
    @@tumblr_json_fixtures[type].select { |fixture| fixture['id'] == id }.first
  end
end
