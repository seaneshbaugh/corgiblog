module Admin
  class TagsController < AdminController
    def index
      tokens = params[:q].split(/[^[:alnum:]]+/).map(&:downcase).each_with_object({}) { |token, v| v[v.length.to_s] = { 'value' => token } }

      query = {
        'g' => {
          '0' => {
            'm' => 'and',
            'c' => {
              '0' => {
                'a' => {
                  '0' => {
                    'name' => 'name'
                  },
                },
                'p' => 'cont_any',
                'v' => tokens
              }
            }
          }
        }
      }

      @search = ActsAsTaggableOn::Tag.search(query)

      @tags = @search.result

      render json: @tags.map(&:name).to_json
    end
  end
end
