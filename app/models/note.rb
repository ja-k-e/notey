class Note < ActiveRecord::Base
  belongs_to :user, inverse_of: :notes

  validates :message, presence: true
  validates :color, format: /\A#[a-fA-F0-9]{3}([a-fA-F0-9]{3})?\z/, allow_blank: true

  before_save :default_values
  def default_values
    self.color ||= '#FFF'
  end

  def filtered_message
    ::Filters::Emoji.new(message).text
  end
end
