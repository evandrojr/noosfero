class AlterColumnArticleVersionsStartDate < ActiveRecord::Migration
  def up
    change_table :article_versions do |t|
      t.change :start_date, :datetime
    end
  end

  def down
    change_table :article_versions do |t|
      t.change :start_date, :date
    end
  end
end