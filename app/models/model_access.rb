class ModelAccess < FieldAccess

  def accessible?(model)
    !(blacklist.include?(key_for(model)) || blacklist.include?(any_offer_key_for(model)))
  end

  def key_for(model)
    [@offer, @utilization, model].join('.')
  end

  def any_offer_key_for(model)
    ['*', @utilization, model].join('.')
  end

  def self.cms_blacklist
    %w(
      *.parking.additional_description
    )
  end
end
