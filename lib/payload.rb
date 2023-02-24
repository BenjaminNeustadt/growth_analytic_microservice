class Payload
 
 include DataFormatters
 
  private
 
  def initialize(data)
    @data = JSON.parse(data)
  end
 
  public
 
  attr_reader :data
 
  def process
    data.key?("name") ? process_event : process_pageview
  end

end
