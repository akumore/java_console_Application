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

    it 'returns the html cache key' do
      handout.real_estate.stub!(:id).and_return('123')
      handout.cache_key(:html, :de).should == "/de/real_estates/123/handout.html"
    end

    it 'return the pdf cache key' do
      handout.real_estate.stub!(:id).and_return('456')
      handout.cache_key(:pdf, :de).should == "/de/real_estates/456/Printout_Objektdokumentation-some-real-estate.pdf"
    end
  end

  describe '#to_pdf' do
    it 'returns rendered pdf file' do
      host = 'http://host/doc.html'
      expectation = 'yes, this is pdf'
      handout.should_receive(:html_url).and_return(host)
      PDFKit.should_receive(:new).with(host).and_return mock(PDFKit, :to_pdf => expectation)
      handout.to_pdf.should == expectation
    end
  end

  describe '#to_file' do
    it 'saves a pdf file' do
      host = 'http://host/doc.html'
      filename = 'my-filename.pdf'
      pdf_mock = mock(PDFKit)

      handout.should_receive(:html_url).and_return(host)
      PDFKit.should_receive(:new).with(host).and_return pdf_mock
      pdf_mock.should_receive(:to_file).with(filename)
      handout.to_file(filename)
    end
  end
end
