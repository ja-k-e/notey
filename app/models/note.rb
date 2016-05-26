class Note < ActiveRecord::Base
  belongs_to :user, inverse_of: :notes

  validates :message, presence: true
end
