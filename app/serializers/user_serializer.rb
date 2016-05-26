class UserSerializer < ActiveModel::Serializer
  attributes :username

  has_many :notes
  class NoteSerializer < ActiveModel::Serializer
    attributes :color, :message, :hashid, :slack_user
  end
end
