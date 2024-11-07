class Task < ApplicationRecord
  belongs_to :user

  enum status: {
    to_do: 0,
    in_progress: 1,
    in_review: 2,
    completed: 3,
    on_hold: 4,
    cancelled: 5,
    blocked: 6,
    pending: 7
  }
end
