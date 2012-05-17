# encoding: utf-8

require 'active_support/all'
require 'microsite/assemble_real_estate_chapters'

class PricingDecorator; end
class InfrastructureDecorator; end

module Microsite
  describe AssembleRealEstateChapters do
    let :pricing_decorator do
      stub(:chapter => pricing_chapter)
    end

    let :infrastructure_decorator do
      stub(:chapter => infrastructure_chapter)
    end

    context 'with pricing and infrastructure attributes' do
      before do
        PricingDecorator.should_receive(:decorate).with(pricing).and_return(pricing_decorator)
        InfrastructureDecorator.should_receive(:decorate).with(infrastructure).and_return(infrastructure_decorator)
      end

      let :real_estate_with_pricing_and_infrastructure do
        stub( :pricing => pricing, :infrastructure => infrastructure)
      end

      let :pricing do
        stub(:present? => true)
      end

      let :infrastructure do
        stub(:present? => true)
      end

      let :chapter_not_blank do
        chapter = stub()
        chapter.should_receive(:[]).any_number_of_times.with(:content).and_return([{:key => 'value' }])
        chapter.should_receive(:[]).any_number_of_times.with(:content_html).and_return('<p>not empty</p>')
        chapter
      end

      let :chapter_blank do
        chapter = stub()
        chapter.should_receive(:[]).any_number_of_times.with(:content).and_return([])
        chapter.should_receive(:[]).any_number_of_times.with(:content_html).and_return('')
        chapter
      end

      context 'and with both content/content_html not blank' do

        let :pricing_chapter do
          chapter_not_blank
        end

        let :infrastructure_chapter do
          chapter_not_blank
        end

        it 'returns both chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_infrastructure
          chapters.should == [ pricing_chapter, infrastructure_chapter ]
        end
      end

      context 'with both content/content_html blank' do
        let :pricing_chapter do
          chapter_blank
        end

        let :infrastructure_chapter do
          chapter_blank
        end

        it 'returns both chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_infrastructure
          chapters.should == []
        end
      end

      context 'with only content_html/content blank' do

        let :pricing_chapter do
          chapter = stub()
          chapter.should_receive(:[]).any_number_of_times.with(:content).and_return([])
          chapter.should_receive(:[]).any_number_of_times.with(:content_html).and_return('<p>not blank</p>')
          chapter
        end

        let :infrastructure_chapter do
          chapter = stub()
          chapter.should_receive(:[]).any_number_of_times.with(:content).and_return([{:key => 'value'}])
          chapter.should_receive(:[]).any_number_of_times.with(:content_html).and_return('')
          chapter
        end

        it 'returns both chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_infrastructure
          chapters.should == [ pricing_chapter, infrastructure_chapter ]
        end
      end
    end

    context 'without pricing and infrastructure attributes' do

      let :real_estate_with_pricing_and_infrastructure do
        stub( :pricing => pricing, :infrastructure => infrastructure)
      end

      let :pricing do
        stub(:present? => false)
      end

      let :infrastructure do
        stub(:present? => false)
      end

      it 'returns no chapters' do
        chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_infrastructure
        chapters.should == []
      end
    end

  end

end
