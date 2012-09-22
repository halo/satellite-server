class Object

  def underscored_class_name
    self.class.underscored_class_name
  end

  def self.underscored_class_name
    name.split('::').last.underscore.to_sym
  end

end