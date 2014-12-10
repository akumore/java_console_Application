require 'spec_helper'

describe Provider do
  subject { Provider }

  describe '#elements' do

    it 'returns correct elements' do
      expect(subject.elements('immoscout24')).to eq %w(b li br ul)
      expect(subject.elements('homegate')).to eq %w(b li br ul)
      expect(subject.elements('home_ch')).to eq %w(b li br)
      expect(subject.elements('immostreet')).to eq %w(b li br)
      expect(subject.elements('aclado')).to eq %w(b li br)
    end

  end

end
