require_relative './event_attributions'

module DataFormatters

 include EventAttributionsHelper

  def process_pageview

    {
      fingerprint:    fingerprint,
      user_id:        user_id ,
      url:            url,
      referrer_url:   referrer_url,
      created_at:     created_at
    }
  end

  def process_event
    {
      name:           name,
      fingerprint:    fingerprint,
      user_id:        user_id ,
      created_at:     created_at
    }
  end

end

