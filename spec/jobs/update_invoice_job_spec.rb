require "rails_helper"

RSpec.describe UpdateInvoiceJob do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    invoice = create(:invoice)
    perform_job do
      UpdateInvoiceJob.new.perform(invoice.id)
    end
  end
end