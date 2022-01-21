# frozen_string_literal: true

ActiveJob::Status.store = :file_store, '/tmp'
ActiveJob::Status.options = { expires_in: 3.days.to_i }
