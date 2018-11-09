class SessionsController < Devise::SessionsController
  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
    render status: 200, json: {success: true, token: current_token}
  end

  def show
    if user_signed_in?
      render json: { user: {id: current_user.id, name: current_user.name, email: current_user.email, roles: current_user.roles.map{|v| v.name}}}
    end
  end



  private

  def current_token
    request.env['warden-jwt_auth.token']
  end
end