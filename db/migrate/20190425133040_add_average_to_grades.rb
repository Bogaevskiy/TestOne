class AddAverageToGrades < ActiveRecord::Migration[5.1]
  def change
    add_column :grades, :average, :float, default: 0.0
  end
end
