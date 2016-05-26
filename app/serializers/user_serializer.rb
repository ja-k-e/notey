class UserSerializer < ActiveModel::Serializer
  attributes :username

  has_many :notes
  class NoteSerializer < ActiveModel::Serializer
    attributes :color, :filtered_message, :hashid, :slack_user
  end
end
