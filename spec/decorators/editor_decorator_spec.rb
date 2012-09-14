# encoding: utf-8
require 'spec_helper'

describe EditorDecorator do
  let :default_admin_user do
    EditorDecorator.decorate Fabricate(:cms_admin, :first_name => 'Admin', :last_name => 'Unbekannt')
  end

  let :default_editor_user do
    EditorDecorator.decorate Fabricate(:cms_editor, :first_name => 'Editor', :last_name => 'Unbekannt')
  end

  let :real_user do
    EditorDecorator.decorate Fabricate(:cms_editor, :first_name => 'Hans', :last_name => 'Wurst')
  end

  describe '#full_name' do
    context 'for the default Editor or Admin user' do
      it 'returns Unbekannt' do
        default_admin_user.full_name.should == 'Unbekannt'
        default_editor_user.full_name.should == 'Unbekannt'
      end
    end

    context 'for any real user' do
      it 'returns the full name' do
        real_user.full_name.should == 'Hans Wurst'
      end
    end
  end

end
