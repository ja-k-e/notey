class NotesController < ApplicationController
  before_action :authorize, only: [:create, :update]
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :authorize_slack, only: [:slack]
  before_action :authorize_owner, only: [:update, :destroy]

  def index
    @notes = Note.all.order('created_at DESC').limit(20)

    render json: @notes
  end

  def show
    render json: @note
  end

  def create
    @note = @current_user.notes.new(note_params)

    if @note.save
      render json: @note, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def slack
    @current_user = User.find_or_create_by(username: slack_note_params[:team_domain])

    text = slack_note_params[:text]

    image = text.match(%r(https?:\/\/[^ ]+\.(jpg|gif|png)))
    if image
      text = text.gsub(image[0], '').gsub('<>', '')
      image = image[0]
    else
      image = nil
    end
    text = text.gsub('notey ', '')
    color = text.match(/\A#[0-9a-fA-Z]+ /)
    if color
      text = text.gsub(color[0], '')
      color = color[0].delete(' ')
    else
      color = '#FFF'
    end

    slack_params = {
      slack_user: slack_note_params[:user_name],
      message: text,
      color: color,
      image_url: image
    }

    @note = @current_user.notes.new(slack_params)

    if @note.save
      render json: {
        text: 'Note created, yo! jakealbaugh.com/wall' }, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def update
    @note = Note.find_by_hashid(params[:hashid])

    if @note.update(note_params)
      head :no_content
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy

    head :no_content
  end

  private

  def set_note
    begin
      @note = Note.find_by_hashid(params[:hashid])
    rescue
      render_not_found('Note', params[:hashid])
    end
  end

  def slack_note_params
    params.permit(:team_domain, :user_name, :text, :token)
  end

  def note_params
    params.require(:note).permit(:message, :color, :image_url)
  end

  def authorize_owner
    current_user
    @current_user.admin || @current_user == @note.user
  end
end
