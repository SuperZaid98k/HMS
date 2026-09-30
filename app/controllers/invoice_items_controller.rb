class InvoiceItemsController < ApplicationController
  before_action :authenticate_user!
  load_resource :invoice
  load_and_authorize_resource :invoice_item, through: :invoice

  def create
    if @invoice_item.save
      recalculate_invoice_total(@invoice)
      redirect_to @invoice, notice: 'Item added to invoice.'
    else
      redirect_to @invoice, alert: 'Failed to add invoice item.'
    end
  end

  def destroy
    @invoice_item.destroy
    recalculate_invoice_total(@invoice)
    redirect_to @invoice, notice: 'Item removed from invoice.'
  end

  private

  def invoice_item_params
    params.require(:invoice_item).permit(:description, :quantity, :amount)
  end

  def recalculate_invoice_total(invoice)
    total = invoice.invoice_items.sum { |i| (i.amount.to_f * (i.quantity.presence || 1).to_f) }
    invoice.update(total_amount: total.to_s)
  end
end
