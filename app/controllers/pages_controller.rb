# app/controllers/pages_controller.rb (or HomeController)
class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:about_us] # Devise bypass

  def about_us
    # Optionally load any dynamic data, e.g. for the inquiry form
    @contact_message = ContactMessage.new if defined?(ContactMessage)
  end
end