class Cms::DashboardsController < Cms::SecuredController

  respond_to :html
  
  def show
    review_count = RealEstate.in_review.recently_updated.count

    if review_count > 0 and current_user.admin?
      flash.now[:notice] = t('cms.dashboards.real_estates_for_review', :count => review_count)
    end
  end
end