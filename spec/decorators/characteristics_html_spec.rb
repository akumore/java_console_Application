# encoding: utf-8
require 'spec_helper'

describe CharacteristicsHtml do

  let(:decorator) do
    stub(InformationDecorator,
         field_html: 'abc',
         real_estate: real_estate,
         new_record?: false,
         model_class: Information)
  end

  let(:real_estate) do
    stub(RealEstate, id: '999', language: 'de').tap {|re|
      re.stub(:information) do
        stub(Information, decorate: decorator)
      end
    }
  end

  before do
    RealEstate.stub(:find) { real_estate }
  end

  subject { CharacteristicsHtml.new(decorator, :field) }

  describe '#update_list' do

    context 'new record' do
      before do
        RealEstate.should_not_receive(:find)
        decorator.stub(:new_record? => true)
      end

      its 'does not update field when no characteristics are available' do
        decorator.should_receive(:field_list_in_real_estate_language).
          with('field_characteristics').
          and_return([])
        decorator.should_not_receive('field_html=')
        expect(subject.update).to be_false
      end

      its 'does insert new characteristics' do
        decorator.should_receive('field_html=').with("<ul>\r\na\r\nb\r\n</ul>\r\nabc")
        decorator.should_receive(:field_list_in_real_estate_language).
          with('field_characteristics').
          and_return(['a','b'])
        expect(subject.update).to be_true
      end
    end

    context 'nothing changed' do


      it 'does not update anything if characteristics did not change' do
        decorator.should_receive(:field_list_in_real_estate_language).
          exactly(2).times.
          with('field_characteristics').
          and_return(['x','y'])
        decorator.should_not_receive('field_html=')
        expect(subject.update).to be_false
      end
    end

    context 'something changed' do

      let(:changed_real_estate) do real_estate end

      let(:changed_decorator) do
        stub(InformationDecorator,
             real_estate: changed_real_estate,
             model_class: Information,
             field_html: "<ul>\r\na\r\n</ul>\r\nabc",
             new_record?: false)
      end

      before do
        RealEstate.stub(:find) { real_estate }
        decorator.stub(field_list_in_real_estate_language: ['a','b'])
      end

      subject { CharacteristicsHtml.new(changed_decorator, :field) }

      it 'insert new list items' do
        changed_decorator.should_receive(:field_list_in_real_estate_language).
          with('field_characteristics').
          and_return(['a','b','c'])
        changed_decorator.should_receive('field_html=').
          with("<ul>\r\na\r\nc\r\n</ul>\r\nabc")
        expect(subject.update).to be_true
      end

      it 'create new ul when nothing is there' do
        changed_decorator.should_receive(:field_html).and_return('abc')
        changed_decorator.should_receive(:field_list_in_real_estate_language).
          with('field_characteristics').
          and_return(['a','b', 'c'])
        changed_decorator.should_receive('field_html=').
          with("<ul>\r\nc\r\n</ul>\r\nabc")
        expect(subject.update).to be_true
      end

      context 'changed language' do

        let(:changed_real_estate) do
          stub(RealEstate, id: '999', language: 'en').tap {|re|
            re.stub(:information) do
              stub(Information, decorate: decorator)
            end
          }
        end

        it 'raises an error if original cannot be mapped to new' do
          decorator.should_receive(:field_list_in_real_estate_language).
            with('field_characteristics').
            and_return(["aDE", "bDE"])
          changed_decorator.should_receive(:field_list_in_real_estate_language).
            with('field_characteristics').
            and_return(["aEN", "bEN", "cEN"])
          changed_decorator.should_receive(:field_html).and_return("<ul>\r\naDE\r\ncDE\r\n</ul>\r\nabc")
          changed_decorator.should_not_receive(:field_html=)
          expect { subject.update }.to raise_error("Mapping not possible. (2 != 3)")
        end

        it 'replaces old language content with new translations' do
          decorator.should_receive(:field_list_in_real_estate_language).
            with('field_characteristics').
            and_return(["aDE", "bDE", "cDE"])
          changed_decorator.should_receive(:field_list_in_real_estate_language).
            with('field_characteristics').
            and_return(["aEN", "bEN", "cEN"])
          changed_decorator.should_receive(:field_html).and_return("<ul>\r\naDE\r\ncDE\r\n</ul>\r\nabc")
          changed_decorator.should_receive(:field_html=).with("<ul>\r\naEN\r\ncEN\r\n</ul>\r\nabc")
          expect(subject.update).to be_true
        end
      end

    end

  end
end
