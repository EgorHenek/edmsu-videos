class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :youtube_url, unique: true, null: false
      t.string :youtube_id, unique: true, null: false
      t.datetime :published_at
      t.text :description
      t.string :avatar
      t.integer :duration
      t.boolean :is_stream, default: false
      t.datetime :stream_start
      t.datetime :stream_end
      t.string :slug, unique: true
      t.belongs_to :user
      t.belongs_to :channel
      t.timestamps
    end
  end
end
