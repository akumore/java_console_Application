class FixTypoedCategory < Mongoid::Migration
  def self.up

    typo_cat = Category.where(:name => 'aterlier').first
    fixed_cat = Category.where(:name => 'atelier').first

    if typo_cat.present?
      raise "Category with fixed typo not found. Please run seeds task" unless fixed_cat

      typo_cat.real_estates.each do |real_estate|
        real_estate.category = fixed_cat
        real_estate.save(:validate => false)
      end

      typo_cat.destroy
    end
  end

  def self.down
  end
end