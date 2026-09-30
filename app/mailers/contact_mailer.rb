class ContactMailer < ApplicationMailer
default from: "mz7218790990@gmail.com"

  def inquiry_received(contact_message)
    @contact_message = contact_message

    mail(
      to: @contact_message.email,
      subject: "We have received your inquiry | HMS Healthcare"
    )
  end
end
