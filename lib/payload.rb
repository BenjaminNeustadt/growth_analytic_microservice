class Payload
 
 include DataFormatters
 
  private
 
  def initialize(data)
    @data = data
  end
 
  public
 
  attr_reader :data
 
  def process
   data.key?("name") ? process_event : process_view
  end

end
