class AlterColumnArticlesEndDate < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.change :end_date, :datetime
    end
  end

  def down
    change_table :articles do |t|
      t.change :end_date, :date
    end
  end
end
