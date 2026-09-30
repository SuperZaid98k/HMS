class HomeController < ApplicationController
    skip_before_action :authenticate_user!
    def index
        # Preload user, specializations, and nested department -> hospital
        @doctor_profiles = DoctorProfile.includes(
        :user, 
        :specializations, 
        department: :hospital
        ).all

        @hospitals = Hospital.all
        @specializations = Specialization.all
    end
end
