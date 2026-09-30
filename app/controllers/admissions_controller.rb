class AdmissionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @admissions = @admissions.includes(:patient, bed: { room: :ward })
  end

  def show
  end

  def new
    @admission.patient_id = params[:patient_id] if params[:patient_id].present?
    @admission.bed_id = params[:bed_id] if params[:bed_id].present?
    @admission.admitted_at ||= Time.current.to_s
    @admission.status ||= "admitted"
  end

  def create
    if @admission.save
      update_bed_status(@admission)
      redirect_to @admission, notice: 'Patient admission recorded successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @admission.update(admission_params)
      update_bed_status(@admission)
      redirect_to @admission, notice: 'Admission details updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    bed = @admission.bed
    @admission.destroy
    bed.update(status: 'free') if bed
    redirect_to admissions_path, notice: 'Admission record deleted.'
  end

  private

  def admission_params
    params.require(:admission).permit(:patient_id, :bed_id, :admitted_at, :discharged_at, :status)
  end

  def update_bed_status(admission)
    if admission.status == 'admitted' && admission.bed
      admission.bed.update(status: 'occupied')
    elsif admission.status == 'discharged' && admission.bed
      admission.bed.update(status: 'free')
    end
  end
end
