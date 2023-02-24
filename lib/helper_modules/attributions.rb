module Attributions

  def data
    @data
  end

  def fingerprint
  data['fingerprint']
  end

  def user_id
    data['user_id']
  end

  def url
    data['url']
  end

  def referrer_url
    data['referrer_url']
  end

  def created_at
    data['created_at']
  end

  def name
    data['name']
  end

end
