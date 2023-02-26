module Routes

  def self.registered app

    app.post('/event') {event_webhook}
    app.post('/pageview') {pageview_webhook}
    app.get('/') {event_endpoint}

  end

end
