class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Exception do |e|
    render json: {error: e.message}, status: 500
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :not_found
  end

  rescue_from CanCan::AccessDenied do |e|
    render json: {"message" => "unauthorized"}.to_json, status: :forbidden
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

end
