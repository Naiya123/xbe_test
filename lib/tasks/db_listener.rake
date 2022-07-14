# frozen_string_literal: true

namespace :db_listner do
  desc 'Start the Database changes listner'
  task run: :environment do
    Signal.trap('INT') { exit(0) }
    Signal.trap('TERM') { exit(0) }

    Listener.listen('line_item', listen_timeout: 30, notify_only: false) do |listener|
      listener.on_start do
        puts 'Listener is starting'
      end

      listener.on_notify do |payload|
        parsed_payload = JSON.parse(payload)
        UpdateInvoiceJob.perform_async(parsed_payload.dig('record', 'invoice_id'))
      end

      listener.on_timeout do
        puts 'Listener is timedout'
      end
    end
  end
end
