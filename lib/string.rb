class String
  def remove_ending char
    new_string = self
    while new_string.ends_with? char
      new_string = new_string[0..-2]
    end
    return new_string
  end
end

