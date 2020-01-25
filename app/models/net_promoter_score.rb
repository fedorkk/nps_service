# frozen_string_literal: true

class NetPromoterScore < ApplicationRecord
  validates :score, :touchpoint, :respondent_class, :respondent_id, :object_class, :object_id, presence: true
  validates :touchpoint, uniqueness: { scope: %i[respondent_class respondent_id object_class object_id] }
  validates :respondent_id, numericality: { only_integer: true }
  validates :object_id, numericality: { only_integer: true }
  validates :score, numericality: { only_integer: true, less_than_or_equal_to: 10, greater_than_or_equal_to: 0 }
end
