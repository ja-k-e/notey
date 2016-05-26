class NotesController < ApplicationController
  before_action :authorize, only: [:create, :update]
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :authorize_owner, only: [:update, :destroy]

  def index
    @notes = Note.all.order('created_at DESC')

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

  def note_params
    params.require(:note).permit(:message, :color)
  end

  def authorize_owner
    current_user
    @current_user.admin || @current_user == @note.user
  end
end
