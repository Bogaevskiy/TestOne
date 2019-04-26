class AddPostToGrades < ActiveRecord::Migration[5.1]
  def change
    add_reference :grades, :post, foreign_key: true
  end
end
