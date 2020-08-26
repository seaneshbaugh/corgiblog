# frozen_string_literal: true

Rails.application.config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden
