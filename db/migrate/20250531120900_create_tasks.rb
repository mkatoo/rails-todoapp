class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :content, null: false
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
