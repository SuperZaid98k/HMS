Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"

  get "/dashboard", to: "dashboard#index"

  resources :hospitals do
    resources :departments
  end
  get "/staff_management", to: "users#index"
  resources :users
  shallow do
    resources :hospitals do
      resources :wards do
        resources :rooms do
          resources :beds do
            resources :admissions
          end
        end
      end
    end
  end

  resources :specializations
  resources :treatments
  resources :medicines

  # People Management
  resources :doctor_profiles
  resources :staff_profiles
  resources :patients do
    resources :insurance_policies, only: [:new, :create]
  end
  resources :patient_profiles

  # Clinical & Operations
  resources :appointments do
    resources :appointment_notes, only: [:create, :destroy]
  end
  resources :medical_records do
    resources :treatment_assignments, only: [:create, :destroy]
  end
  resources :prescriptions do
    resources :prescription_items, only: [:create, :destroy]
  end
  resources :lab_tests do
    resource :lab_test_result, only: [:new, :create, :edit, :update]
  end
  resources :admissions

  # Billing & Documents
  resources :invoices do
    resources :invoice_items, only: [:create, :destroy]
    resources :payments, only: [:create]
  end
  resources :insurance_policies
  resources :documents, only: [:create, :destroy]


  # Public contact page and form submission
  get  "/contact-us", to: "contact_messages#new", as: :contact_us
  post "/contact-us", to: "contact_messages#create"

  # Admin listing and management
  resources :contact_messages, only: [:index, :show, :destroy]
  get "/about-us", to: "pages#about_us", as: :about_us

  # Use letter_opener to preview emails in your browser
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "/partner-with-us", to: "hospital_requests#new", as: :partner_with_us
  resources :hospital_requests, only: [:new, :create, :show]

  # Solid Queue dashboard via Mission Control Jobs
  authenticate :user, ->(user) { user.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end
end