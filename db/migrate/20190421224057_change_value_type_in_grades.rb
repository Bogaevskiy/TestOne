class ChangeValueTypeInGrades < ActiveRecord::Migration[5.1]
  def change
  	remove_column :grades, :value
  	add_column :grades, :value, :integer, array: true, default: []
  end
end
