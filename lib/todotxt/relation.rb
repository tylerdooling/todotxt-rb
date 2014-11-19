class Relation < Struct
  def initialize(hash = {})
    super *(hash.values_at(*members))
  rescue ArgumentError => error
    diff = hash.keys - members
    raise error, "Unknown attributes #{diff}"
  end

  def members
    @members ||= super
  end
end
