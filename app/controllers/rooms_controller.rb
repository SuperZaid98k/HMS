class RoomsController < ApplicationController
  load_and_authorize_resource :ward, only: [:new, :create]
  load_and_authorize_resource :room, through: :ward, only: [:new, :create]
  load_and_authorize_resource :room, only: [:show, :edit, :update, :destroy]

  def show
    @ward = @room.ward
  end

  def new
  end

  def create
    if @room.save
      redirect_to ward_path(@ward), notice: "Room was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @ward = @room.ward
  end

  def update
    if @room.update(room_params)
      redirect_to ward_path(@room.ward), notice: "Room was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ward = @room.ward
    @room.destroy
    redirect_to ward_path(ward), notice: "Room was successfully deleted."
  end

  private

  def room_params
    # Check your db/schema.rb: column names MUST match these symbols exactly
    params.require(:room).permit(:room_number, :room_type)
  end
end