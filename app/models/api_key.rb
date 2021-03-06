require 'singleton'

class ApiKey < ActiveRecord::Base
  include ActiveRecord::Singleton
  before_create :generate_access_token
  
  def hashed_token
    Digest::SHA1.hexdigest(self.access_token +
                           Date.current.strftime('%Y%m%d') +
                           Time.zone.now.strftime('%H%M'))
  end  

  def authenticate_with(token)
    token == self.hashed_token
  end
 
private

  def generate_access_token
    self.access_token = SecureRandom.hex
  end 
end  
