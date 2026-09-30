class BedsController < ApplicationController
  load_and_authorize_resource :room, only: [:new, :create]
  load_and_authorize_resource :bed, through: :room, only: [:new, :create]
  load_and_authorize_resource :bed, only: [:show, :edit, :update, :destroy]

  def show
    @room = @bed.room
  end

  def new
  end

  def create
    if @bed.save
      redirect_to room_path(@room), notice: "bed was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @room = @bed.room
  end

  def update
    if @bed.update(bed_params)
      redirect_to room_path(@bed.room), notice: "bed was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    room = @bed.room
    @bed.destroy
    redirect_to room_path(room), notice: "bed was successfully deleted."
  end

  private

  def bed_params
    # Check your db/schema.rb: column names MUST match these symbols exactly
    params.require(:bed).permit(:bed_number, :status)
  end
end