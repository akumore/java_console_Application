require 'spec_helper'

describe RealEstatePagination do
  let :first do
    mock_model(RealEstate)
  end

  let :second do
    mock_model(RealEstate)
  end

  let :last do
    mock_model(RealEstate)
  end

  let :real_estates do
    [first.id, second.id, last.id]
  end

  context 'on the first page' do
    subject do
      RealEstatePagination.new(first, real_estates)
    end

    describe '#prev' do
      it 'returns nil' do
        subject.prev.should be_nil
      end
    end

    describe '#next' do
      it 'returns the second real estate'do
        subject.next.should be == second.id
      end
    end

    describe '#prev?' do
      it 'returns false' do
        subject.prev?.should be_false
      end
    end

    describe '#next?' do
      it 'returns true' do
        subject.next?.should be_true
      end
    end
  end

  context 'on the second page' do
    subject do
      RealEstatePagination.new(second, real_estates)
    end

    describe '#prev' do
      it 'returns the first real estate' do
        subject.prev.should be == first.id
      end
    end

    describe '#next' do
      it 'returns the third real estate' do
        subject.next.should be == last.id
      end
    end

    describe '#prev?' do
      it 'returns true' do
        subject.prev?.should be_true
      end
    end

    describe '#next?' do
      it 'returns true' do
        subject.next?.should be_true
      end
    end
  end

  context 'on the last page' do
    subject do
      RealEstatePagination.new(last, real_estates)
    end

    describe '#prev' do
      it 'returns the second real estate' do
        subject.prev.should be == second.id
      end
    end

    describe '#next' do
      it 'returns nil' do
        subject.next.should be_nil
      end
    end

    describe '#prev?' do
      it 'returns true' do
        subject.prev?.should be_true
      end
    end

    describe '#next?' do
      it 'returns false' do
        subject.next?.should be_false
      end
    end
  end
end

