class AlterColumnArticlesStartDate < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.change :start_date, :datetime
    end
  end

  def down
    change_table :articles do |t|
      t.change :start_date, :date
    end
  end
end
