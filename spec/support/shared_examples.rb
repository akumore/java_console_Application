# encoding: utf-8

share_examples_for "All CMS controllers not accessible to editors" do |resource_name|
  before do
    @request.env["devise.mapping"] = Devise.mappings[:users]
    sign_in Fabricate(:cms_editor)

    @prohibited = 'Sie haben keine Berechtigungen für diese Aktion'
  end

  let :resource do
    Fabricate(resource_name)
  end

  [:new, :index].each do |action|
    it "can not be accessed on ##{action}" do
      get action
      response.should redirect_to cms_dashboards_path
      flash[:warn].should == @prohibited
    end
  end

  it 'can not be accessed on #edit' do
    get :edit, :id => resource.id
    response.should redirect_to cms_dashboards_path
    flash[:warn].should == @prohibited
  end

  it 'can not be accessed for creating new objects' do
    post :create
    response.should redirect_to cms_dashboards_path
    flash[:warn].should == @prohibited
  end

  it 'can not be accessed for updating existing objects' do
    put :update, :id => resource.id
    response.should redirect_to cms_dashboards_path
    flash[:warn].should == @prohibited
  end

  it 'can not be accessed for deleting objects' do
    delete :destroy, :id => resource.id
    response.should redirect_to cms_dashboards_path
    flash[:warn].should == @prohibited
  end
end