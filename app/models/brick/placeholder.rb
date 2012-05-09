class Brick::Placeholder < Brick::Base

  TYPES = %w(jobs_openings jobs_apply_with_success job_profile_slider contact_form company_header)

  field :placeholder, :type => String

  validates :placeholder, :presence => true
end
