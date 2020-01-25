# frozen_string_literal: true

class CreateNetPromoterScores < ActiveRecord::Migration[5.2]
  def change
    create_table :net_promoter_scores do |t|
      t.integer :score, null: false
      t.string :touchpoint, null: false
      t.string :respondent_class, null: false
      t.integer :respondent_id, null: false
      t.string :object_class, null: false
      t.integer :object_id, null: false

      t.timestamps
    end

    # Uniq index to prevent creating of any duplications on the database level
    add_index :net_promoter_scores, %i[respondent_class respondent_id object_class object_id],
              unique: true,
              name: 'duplication_protection_index'

    # Indexes for the faster search by respondent and object
    add_index :net_promoter_scores, [:respondent_class, :respondent_id], name: 'respondent_index'
    add_index :net_promoter_scores, [:object_class, :object_id], name: 'object_index'
  end
end
