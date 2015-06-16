class AlterColumnArticleVersionsEndDate < ActiveRecord::Migration
  def up
    change_table :article_versions do |t|
      t.change :end_date, :datetime
    end
  end

  def down
    change_table :article_versions do |t|
      t.change :end_date, :date
    end
  end
end
