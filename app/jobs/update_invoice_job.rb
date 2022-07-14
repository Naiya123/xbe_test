class UpdateInvoiceJob
  include Sidekiq::Job

  def perform(invoice_id)
    invoice = Invoice.find invoice_id
    invoice.recalculate_total!
  rescue StandardError => e
    puts e.message
  end
end
