require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :set_user

  def set_user 
    gon.current_user = current_user&.id
  end

end
