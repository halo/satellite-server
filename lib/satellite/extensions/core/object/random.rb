require 'securerandom'

class Object

  def random_id
    SecureRandom.hex(4)
  end

end