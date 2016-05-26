class UserSerializer < ActiveModel::Serializer
  attributes :username

  has_many :notes
  class NoteSerializer < ActiveModel::Serializer
    attributes :hashid
  end
end
