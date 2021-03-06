class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

    layout :layout

  private

  def layout
    # only turn it off for login pages:
    current_user ? "application" : "devise/sessions"
  end

end
