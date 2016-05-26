class NoteSerializer < ActiveModel::Serializer
  attributes :message, :color, :hashid, :slack_user

  belongs_to :user
end
