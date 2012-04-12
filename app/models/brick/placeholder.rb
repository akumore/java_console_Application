class Brick::Placeholder < Brick::Base

  TYPES = %w(jobs_openings jobs_apply_with_success contact_form company_header)

  field :placeholder, :type => String

  validates :placeholder, :presence => true
end
