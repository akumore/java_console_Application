require 'spec_helper'

describe RealEstateExhibit do
  let :context do
    ''
  end

  describe '.create' do
    let :figure do
      Figure.new
    end

    it 'returns a typed exhibit' do
      RealEstateExhibit.create(figure, :rent, :living).should == Rent::Living::FigureExhibit
    end

    context 'when using an invalid offer type' do
      it 'fails' do
        expect { RealEstateExhibit.create(figure, :anything, :private) }.to raise_error
      end
    end

    context 'when using an invalid utilization type' do
      it 'fails' do
        expect { RealEstateExhibit.create(figure, :rent, :stuff) }.to raise_error
      end
    end
  end

  describe '#render' do
    it 'delegates to the context' do
      model = Object.new
      exhibit = RealEstateExhibit.new(model, context)
      context.should_receive(:render).with(:partial => 'my_partial', :locals => { :mandatory => false, :model => model })
      exhibit.render('my_partial', :mandatory => false)
    end
  end
end
