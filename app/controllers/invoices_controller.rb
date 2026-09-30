# app/controllers/invoices_controller.rb
class InvoicesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    # Resolved N+1: includes patient profile, doctor profile, items, and payments
    @invoices = @invoices.includes({ patient: :patient_profile }, 
                                  { appointment: :doctor_profile }, 
                                  :invoice_items, 
                                  :payments)
                         .order(created_at: :desc)
  end

  def show
    # Resolved N+1 for single record inspection
    @invoice = Invoice.includes({ patient: :patient_profile }, 
                                { appointment: :doctor_profile }, 
                                :invoice_items, 
                                :payments)
                      .find(params[:id])
  end

  def new
    @invoice.patient_id = params[:patient_id] if params[:patient_id].present?
    @invoice.appointment_id = params[:appointment_id] if params[:appointment_id].present?
    @invoice.invoice_number ||= "INV-#{SecureRandom.random_number(100000..999999)}"
    @invoice.issued_at ||= Time.current
    @invoice.status ||= "due"
    @invoice.invoice_items.build if @invoice.invoice_items.empty?
    load_form_collections
  end

  def create
    @invoice.issued_at ||= Time.current
    @invoice.status ||= "due"

    if @invoice.save
      redirect_to @invoice, notice: "Invoice #{@invoice.invoice_number} created successfully."
    else
      @invoice.invoice_items.build if @invoice.invoice_items.empty?
      load_form_collections
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice.invoice_items.build if @invoice.invoice_items.empty?
    load_form_collections
  end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice, notice: 'Invoice updated successfully.'
    else
      load_form_collections
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice.destroy
    redirect_to invoices_path, notice: 'Invoice deleted successfully.'
  end

  private

  # Eager loads options for dropdowns to eliminate N+1 queries during form rendering
  def load_form_collections
    @patients = Patient.includes(:patient_profile).order(:created_at)
    @appointments = Appointment.includes(:patient, :doctor_profile).order(scheduled_at: :desc).limit(50)
  end

  def invoice_params
    params.require(:invoice).permit(
      :patient_id, :appointment_id, :invoice_number, :issued_at, :total_amount, :status,
      invoice_items_attributes: [:id, :description, :quantity, :amount, :_destroy]
    )
  end
end