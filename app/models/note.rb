class Note < ActiveRecord::Base
  belongs_to :user, inverse_of: :notes

  validates :message, presence: true
  validates :color, format: /#[a-zA-Z0-9]{3}([a-zA-Z0-9]{3})?/i
end
