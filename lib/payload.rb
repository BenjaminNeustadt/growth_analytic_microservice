class Payload
 
 include DataFormatters
 
  private
 
  def initialize(data)
    @data = data
  end
 
  public
 
  attr_reader :data
 
  def process
    data.key?("name") ? process_event : process_pageview
  end

end

# def extract
#   @data.keys.each_with_object({}) { |item, keyword_arguments| keyword_arguments[item.intern] = @data[item] }
# end