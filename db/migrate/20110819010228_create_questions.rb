class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :user, :null => false
      t.string :title, :null => false
      t.text :content
      t.integer :credit, :default => 0
      t.decimal :money, :precision => 8, :scale => 2, :default => 0
      t.datetime :expire_time
      t.integer :answers_count, :default => 0
      t.integer :correct_answer_id, :default => 0

      t.timestamps
    end
    add_index :questions, :user_id
  end
end
