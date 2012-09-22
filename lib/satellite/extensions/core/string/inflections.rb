# See https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/methods.rb

class String

  # Makes an underscored, lowercase form from the expression in the string.
  #
  # Changes '::' to '/' to convert namespaces to paths.
  #
  # Examples:
  #   "ActiveModel".underscore         # => "active_model"
  #   "ActiveModel::Errors".underscore # => "active_model/errors"
  #
  # As a rule of thumb you can think of +underscore+ as the inverse of +camelize+,
  # though there are cases where that does not hold:
  #
  #   "SSLError".underscore.camelize # => "SslError"
  def underscore
    word = self.to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end


end