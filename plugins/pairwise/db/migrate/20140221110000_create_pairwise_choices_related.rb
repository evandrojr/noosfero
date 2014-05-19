class CreatePairwiseChoicesRelated < ActiveRecord::Migration
  def self.up
    create_table :pairwise_plugin_choices_related do |t|
      t.integer :choice_id
      t.integer :parent_choice_id
      t.references :question
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :pairwise_plugin_choices_related
  end
end