class Cms::SecuredController < ApplicationController
  before_filter :authenticate_user!
  layout 'cms/application'
  respond_to :html

  def next_state(real_estate)
    return real_estate.state_name unless real_estate.valid?
    case real_estate.state_name
      when :editing
        current_user.is_admin? ? :published : :in_review
      when :in_review
        current_user.is_admin? ? :published : :in_review
      else
        :editing
    end
  end

  helper_method :next_state

end