# encoding: utf-8

require 'active_support/all'
require 'microsite/assemble_real_estate_chapters'

class PricingDecorator; end
class FigureDecorator; end

module Microsite
  describe AssembleRealEstateChapters do
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

    let :pricing_decorator do
      stub(:chapter => pricing_chapter)
    end

    let :figure_decorator do
      stub(:chapter => figure_chapter)
    end

    context 'with pricing and figure attributes' do
      before do
        PricingDecorator.should_receive(:decorate).with(pricing).and_return(pricing_decorator)
        FigureDecorator.should_receive(:decorate).with(figure).and_return(figure_decorator)
      end

      let :real_estate_with_pricing_and_figure do
        fa = FieldAccess.new(offer, 'living', FieldAccess.cms_blacklist)
        stub(:offer => offer, :pricing => pricing, :figure => figure,
             :description => nil, :title => nil, :information => nil,
             :utilization => 'living', :field_access => fa)
      end

      let :pricing do
        stub(:present? => true)
      end

      let :figure do
        stub(:present? => true)
      end

      let :offer do
        stub()
      end

      context 'and with both content/content_html not blank' do
        let :pricing_chapter do
          chapter_not_blank
        end

        let :figure_chapter do
          chapter_not_blank
        end

        it 'returns all chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_figure
          chapters.should == [ pricing_chapter, figure_chapter ]
        end
      end

      context 'with both content/content_html blank' do
        let :pricing_chapter do
          chapter_blank
        end

        let :figure_chapter do
          chapter_blank
        end

        it 'returns all chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_figure
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

        let :figure_chapter do
          chapter = stub()
          chapter.should_receive(:[]).any_number_of_times.with(:content).and_return([{:key => 'value'}])
          chapter.should_receive(:[]).any_number_of_times.with(:content_html).and_return('')
          chapter
        end

        it 'returns all chapters with the corresponding decorators' do
          chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_figure
          chapters.should == [ pricing_chapter, figure_chapter ]
        end
      end
    end

    context 'without pricing and figure attributes' do
      let :real_estate_with_pricing_and_figure do
        fa = FieldAccess.new(offer, 'living', FieldAccess.cms_blacklist)
        stub(:offer => offer, :pricing => pricing, :figure => figure,
             :description => nil, :title => nil, :information => nil,
             :utilization => 'living', :field_access => fa)
      end

      let :pricing do
        stub(:present? => false)
      end

      let :figure do
        stub(:present? => false)
      end

      let :offer do
        stub()
      end

      it 'returns no chapters' do
        chapters = AssembleRealEstateChapters.get_chapters real_estate_with_pricing_and_figure
        chapters.should == []
      end
    end

  end

end
