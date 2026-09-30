# app/mailers/hospital_request_mailer.rb
class HospitalRequestMailer < ApplicationMailer
  default from: "mz7218790990@gmail.com"

  def submission_confirmation(hospital_request)
    @hospital_request = hospital_request
    
    mail(
      to: @hospital_request.email,
      subject: "Application Received: #{@hospital_request.hospital_name} - Token ##{@hospital_request.id} | HMS Healthcare"
    )
  end
end