class ChangePostsAndSubsTables < ActiveRecord::Migration
  def up
    remove_column :posts, :sub_id
  end

  def down
    add_column :posts, :sub_id, :integer, null: false, index: true
  end
end
