
class ContactMessagesController < ApplicationController
  # Allow guests to see the form and submit messages
  skip_before_action :authenticate_user!, only: [:new, :create]
  load_and_authorize_resource

  def index
    # List all inquiries ordered by latest first
    @contact_messages = ContactMessage.order(created_at: :desc)
    @hospital_requests = HospitalRequest.order(created_at: :desc)
  end

  def show
    # @contact_message loaded automatically by load_and_authorize_resource
  end

  def new
    @contact_message = ContactMessage.new
    # If a user is logged in, prefill their details
    if user_signed_in?
      @contact_message.name = current_user.name if current_user.respond_to?(:name)
      @contact_message.email = current_user.email
    end
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save

      ContactMailer.inquiry_received(@contact_message).deliver_later

      redirect_to contact_us_path, notice: "Thank you for reaching out! Your message has been submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @contact_message.destroy
    redirect_to contact_messages_path, notice: "Inquiry was deleted successfully."
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :contact_no, :email, :message)
  end
end