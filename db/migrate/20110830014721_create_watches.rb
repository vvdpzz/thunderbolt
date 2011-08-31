class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.references :user
      t.references :question
      t.text :content

      t.timestamps
    end
    add_index :watches, :user_id
    add_index :watches, :question_id
  end
end
