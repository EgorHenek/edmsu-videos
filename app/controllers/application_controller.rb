# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from CanCan::AccessDenied do |_exception|
    render status: :forbidden
  end
end
