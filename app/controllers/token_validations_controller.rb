class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def render_validate_token_success
    render json: @resource, include: [:roles]
  end
end
