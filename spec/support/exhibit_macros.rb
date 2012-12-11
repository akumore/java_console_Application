module ExhibitMacros
  def load_exhibit_setup
    let :model do
      Object.new
    end

    let :context do
      ''
    end

    let :exhibit do
      described_class.new(model, context)
    end
  end
end
