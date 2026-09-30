class PrescriptionItemsController < ApplicationController
  before_action :authenticate_user!
  load_resource :prescription
  load_and_authorize_resource :prescription_item, through: :prescription

  def create
    if @prescription_item.save
      redirect_to @prescription, notice: 'Medicine added to prescription.'
    else
      redirect_to @prescription, alert: 'Failed to add medicine item.'
    end
  end

  def destroy
    @prescription_item.destroy
    redirect_to @prescription, notice: 'Medicine item removed.'
  end

  private

  def prescription_item_params
    params.require(:prescription_item).permit(:medicine_id, :dosage, :frequency, :duration)
  end
end
