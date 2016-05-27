class NoteSerializer < ActiveModel::Serializer
  attributes :filtered_message, :color, :hashid, :slack_user, :image_url

  belongs_to :user
end
