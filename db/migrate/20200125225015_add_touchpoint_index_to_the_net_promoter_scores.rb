# frozen_string_literal: true

class AddTouchpointIndexToTheNetPromoterScores < ActiveRecord::Migration[5.2]
  def change
    add_index :net_promoter_scores, :touchpoint
  end
end
