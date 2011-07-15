class Numeric
  def seconds
    self
  end

  def minutes
    self * 60
  end

  def hours
    self * 60 *60
  end

  def days
    self * 60 * 60 * 24
  end

  alias :second :seconds
  alias :minute :minutes
  alias :hour   :hours
  alias :day    :days
end