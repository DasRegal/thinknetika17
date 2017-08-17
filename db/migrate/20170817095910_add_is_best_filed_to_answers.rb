class AddIsBestFiledToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :is_best_flag, :boolean, default: false
  end
end
