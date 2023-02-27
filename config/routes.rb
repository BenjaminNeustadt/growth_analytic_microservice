module Routes

  def self.registered app

    app.post('/event') { process_webhook_payload }
    app.post('/pageview') { process_webhook_payload }
    app.get('/') { event_endpoint }

  end

end
