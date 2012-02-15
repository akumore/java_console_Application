class Brick::Placeholder < Brick::Base

  TYPES = %w(jobs_openings jobs_apply_with_success)

  field :placeholder, :type => String

  validates :placeholder, :presence => true
end
