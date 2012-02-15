class Brick::Accordion < Brick::Base
  field :title, :type => String
  field :text, :type => String

  validates :title, :presence => true
  validates :text, :presence => true

  def group_id
    if prev.present? && prev.type == 'accordion'
      prev.group_id.to_s.to_sym
    else
      id.to_s.to_sym
    end
  end
end
