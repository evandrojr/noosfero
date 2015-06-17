class CreateArticleFollowers < ActiveRecord::Migration

def self.up
    create_table :article_followers do |t|
      t.integer :person_id, null: false
      t.integer :article_id, null: false
      t.datetime :since

      t.timestamps
    end
    add_index :article_followers, :person_id
    add_index :article_followers, :article_id
    add_index :article_followers, [:person_id, :article_id], :unique => true
  end

  def self.down
    drop_table :article_followers
  end

end
