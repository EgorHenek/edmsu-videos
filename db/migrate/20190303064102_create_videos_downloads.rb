class CreateVideosDownloads < ActiveRecord::Migration[5.2]
  def change
    create_table :videos_downloads do |t|
      t.datetime :delete_time, null: false
      t.integer :attempts, default: 0
      t.belongs_to :videos, null: false
      t.boolean :deleted, default: false

      t.timestamps
    end
  end
end
