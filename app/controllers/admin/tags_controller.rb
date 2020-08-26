# frozen_string_literal: true

# TODO: Consider moving this to a proper API with some sort of token based authentication.
module Admin
  class TagsController < AdminController
    def index
      @search = ActsAsTaggableOn::Tag.ransack(params[:q])

      @tags = @search.result

      render json: @tags.map(&:name).to_json
    end
  end
end
