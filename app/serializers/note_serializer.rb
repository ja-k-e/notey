class NoteSerializer < ActiveModel::Serializer
  attributes :message, :hashid

  belongs_to :user
end
