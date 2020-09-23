class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: 404
  end

  rescue_from CanCan::AccessDenied do |exception|
    render json: {"message" => "unauthorized"}.to_json, :status => 403
  end
  
end
