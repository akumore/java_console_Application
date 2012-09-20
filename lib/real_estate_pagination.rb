class RealEstatePagination

  def initialize(real_estate, real_estates)
    @real_estate = real_estate
    @real_estates = real_estates
  end

  def prev
    @real_estates[@real_estates.index(@real_estate.id) - 1]
  end

  def next
    @real_estates[@real_estates.index(@real_estate.id) + 1]
  end

  def prev?
    @real_estate.id != @real_estates.first
  end

  def next?
    @real_estate.id != @real_estates.last
  end
end
