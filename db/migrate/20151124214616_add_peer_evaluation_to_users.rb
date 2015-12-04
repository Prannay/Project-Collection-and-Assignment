class AddPeerEvaluationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :peer_evaluation, :text
  end
end
