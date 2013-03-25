# encoding: utf-8
require 'spec_helper'

describe Cms::Preview::RealEstatesController do

  describe 'GET #show' do
    context 'as a cms user' do
      before do
        sign_in(Fabricate(:cms_admin))
      end

      context 'with a simple real estate' do
        let :real_estate do
          Fabricate :real_estate, :category => Fabricate(:category)
        end

        it 'renders successfully the preview' do
          get :show, id: real_estate
          response.should be_success
        end
      end

      context 'with a real estate with prices' do
        let :real_estate do
          Fabricate :real_estate, :category => Fabricate(:category), :pricing => Fabricate.build(:pricing)
        end

        it 'renders successfully the preview' do
          get :show, id: real_estate
          response.should be_success
        end
      end

      context 'with a real estate with prices and figures' do
        let :real_estate do
          Fabricate :real_estate, :category => Fabricate(:category), :pricing => Fabricate.build(:pricing), :figure => Fabricate.build(:figure)
        end

        it 'renders successfully the preview' do
          get :show, id: real_estate
          response.should be_success
        end
      end
    end

    context 'as a website visitor' do
      context 'with a simple real estate' do
        let :real_estate do
          Fabricate :real_estate, :category => Fabricate(:category)
        end

        it 'redirects to sign in form' do
          get :show, id: real_estate
          response.should be_redirect
          response.should redirect_to new_user_session_path
        end
      end
    end
  end
end

