require 'spec_helper'

describe Cms::JobsController do

  context 'as a cms editor' do
    it_should_behave_like "All CMS controllers not accessible to editors", :job
  end

  context 'as a cms admin' do
    describe '#sort' do
      before do
        sign_in(Fabricate(:cms_admin))
      end

      let(:first) { Fabricate :job }
      let(:second) { Fabricate :job }
      let(:third) { Fabricate :job }

      it 'should update the position attribute' do
        post :sort, :jobs => [
          first.id.to_s => { :position => 3 },
          second.id.to_s => { :position => 2 },
          third.id.to_s => { :position => 1 }
        ]
        third.reload.position.should == 1
        second.reload.position.should == 2
        first.reload.position.should == 3
      end
    end
  end

end
