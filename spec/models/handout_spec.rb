require 'spec_helper'

describe Handout do
  let :real_estate do
    RealEstate.new :title => 'Some Real Estate'
  end

  let :handout do
    Handout.new(real_estate)
  end

  it 'has a title' do
    handout.filename.should == 'Objektdokumentation-some-real-estate'
  end

  describe '#cache_key' do
    it 'does not fail' do
      lambda{ handout.cache_key(:html, :de) }.should_not raise_error
    end

    it 'returns a key' do
      handout.real_estate.stub!(:id).and_return('123')
      handout.cache_key(:html, :de).should == "/de/real_estates/123/handout.html"
    end
  end

  describe '#to_pdf' do
    it 'returns rendered pdf file' do
      host = 'http://host/doc.pdf'
      expectation = 'yes, this is pdf'
      handout.should_receive(:real_estate_handout_url).and_return(host)
      PDFKit.should_receive(:new).with('http://host/doc.pdf').and_return mock(PDFKit, :to_pdf => expectation)
      handout.to_pdf.should == expectation
    end
  end
end
