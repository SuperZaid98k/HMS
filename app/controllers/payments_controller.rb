class PaymentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :invoice
  load_and_authorize_resource :payment, through: :invoice

  def create
    @payment.paid_at ||= Time.current.to_s
    @payment.status ||= "completed"

    if @payment.save
      total_paid = @invoice.payments.sum { |p| p.amount.to_f }
      if total_paid >= @invoice.total_amount.to_f && @invoice.total_amount.to_f > 0
        @invoice.update(status: 'paid')
      end
      redirect_to @invoice, notice: 'Payment recorded successfully.'
    else
      redirect_to @invoice, alert: 'Failed to record payment.'
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:amount, :payment_method, :paid_at, :status)
  end
end
