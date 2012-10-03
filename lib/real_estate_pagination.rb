class RealEstatePagination

  # Params
  # - real_estate: RealEstate object
  # - real_estates: Array of RealEstate ids
  def initialize(real_estate, real_estates)
    @real_estate = real_estate
    @real_estates = real_estates
  end

  def prev
    if @real_estates.present? && @real_estate.id != @real_estates.first
      @real_estates[@real_estates.index(@real_estate.id) - 1]
    end
  end

  def next
    if @real_estates.present?
      @real_estates[@real_estates.index(@real_estate.id) + 1]
    end
  end

  def prev?
    if @real_estates.present?
      @real_estate.id != @real_estates.first
    end
  end

  def next?
    if @real_estates.present?
      @real_estate.id != @real_estates.last
    end
  end

  def valid?
    # fail if real estate is not part of the given id list
    @real_estates.present? && @real_estates[@real_estates.index(@real_estate.id)] rescue false
  end
end

