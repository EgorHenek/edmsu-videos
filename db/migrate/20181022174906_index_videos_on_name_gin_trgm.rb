class IndexVideosOnNameGinTrgm < ActiveRecord::Migration[5.2]
  def change
    add_index :videos, :title, using: :gin, opclass: {title: :gin_trgm_ops}
  end
end
