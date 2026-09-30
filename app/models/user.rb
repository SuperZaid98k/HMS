class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :doctor_profile, dependent: :destroy
  has_one :staff_profile, dependent: :destroy
  has_one :patient, dependent: :destroy


  def patient?
    role == 'patient'
  end
  def admin?
    role == 'admin'
  end
  def staff?
    role == 'staff'
  end
  def doctor?
    role == 'doctor'
  end
end
