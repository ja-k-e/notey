class NoteSerializer < ActiveModel::Serializer
  attributes :message, :color, :hashid

  belongs_to :user
end
