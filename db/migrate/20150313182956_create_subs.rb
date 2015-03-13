class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :title, null: false
      t.text :description
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :subs, :users
  end
end
