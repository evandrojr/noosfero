class CreateCustomQueries < ActiveRecord::Migration

  def change
    create_table :virtuoso_plugin_custom_queries do |t|
      t.integer  "environment_id", :null => false
      t.string :name
      t.text :query
      t.text :template
      t.boolean :enabled, :default => true
      t.timestamps
    end
  end

end
