class AppointmentNotesController < ApplicationController
  before_action :authenticate_user!
  load_resource :appointment
  load_and_authorize_resource :appointment_note, through: :appointment

  def create
    @appointment_note.user_id = current_user.id if current_user

    if @appointment_note.save
      redirect_to @appointment, notice: 'Note added successfully.'
    else
      redirect_to @appointment, alert: 'Failed to add note.'
    end
  end

  def destroy
    @appointment_note.destroy
    redirect_to @appointment, notice: 'Note deleted.'
  end

  private

  def appointment_note_params
    params.require(:appointment_note).permit(:content)
  end
end
