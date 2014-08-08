class ChangeCategoryDisplayColorToString < ActiveRecord::Migration

  def self.up
    change_table :categories do |t|
      t.string :display_color_tmp, :limit => 6
    end
    Category.update_all({:display_color_tmp => "ffa500"}, {:display_color => 1})
    Category.update_all({:display_color_tmp => "00FF00"}, {:display_color => 2})
    Category.update_all({:display_color_tmp => "a020f0"}, {:display_color => 3})
    Category.update_all({:display_color_tmp => "ff0000"}, {:display_color => 4})
    Category.update_all({:display_color_tmp => "006400"}, {:display_color => 5})
    Category.update_all({:display_color_tmp => "191970"}, {:display_color => 6})
    Category.update_all({:display_color_tmp => "0000ff"}, {:display_color => 7})
    Category.update_all({:display_color_tmp => "a52a2a"}, {:display_color => 8})
    Category.update_all({:display_color_tmp => "32cd32"}, {:display_color => 9})
    Category.update_all({:display_color_tmp => "add8e6"}, {:display_color => 10})
    Category.update_all({:display_color_tmp => "483d8b"}, {:display_color => 11})
    Category.update_all({:display_color_tmp => "b8e9ee"}, {:display_color => 12})
    Category.update_all({:display_color_tmp => "f5f5dc"}, {:display_color => 13})
    Category.update_all({:display_color_tmp => "ffff00"}, {:display_color => 14})
    Category.update_all({:display_color_tmp => "f4a460"}, {:display_color => 15})
  end

  def self.down
    change_table :categories do |t|
      t.remove :display_color
      t.rename :display_color_tmp, :display_color
    end
  end
end
