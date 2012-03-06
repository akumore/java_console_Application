class Cms::DashboardsController < Cms::SecuredController

  respond_to :html
  
  def show
    review_count = RealEstate.in_review.recently_updated.count

    if review_count > 0 and current_user.admin?
      flash.now[:notice] = t('cms.dashboards.real_estates_for_review', :count => review_count)
    end

    @to_be_reviewed_real_estates = RealEstate.in_review.order([:updated_at, :desc])
    @last_edited_real_estates = RealEstate.editing.order([:updated_at, :desc]).limit(5)
    @last_published_real_estates = RealEstate.published.order([:updated_at, :desc]).limit(5)
  end
end