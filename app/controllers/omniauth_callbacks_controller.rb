class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    raise request.env["omniauth.auth"].to_yaml
  end

  alias_method :twitter, :all 
  alias_method :github, :all
end
