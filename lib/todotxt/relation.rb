class Relation < Struct
  def initialize(hash = {})
    diff = (members | hash.keys) - members
    unless diff.empty?
      raise ArgumentError, "Unknown attributes #{diff}"
    end
    super *(hash.values_at(*members))
  end
end
