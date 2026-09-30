# app/controllers/users_controller.rb
class UsersController < ApplicationController
  load_and_authorize_resource

  PER_PAGE = 15

  def index
    if params[:query].present?
      search_term = "%#{params[:query].strip}%"
      @users = @users.where(
        "LOWER(name) LIKE LOWER(:term) OR LOWER(email) LIKE LOWER(:term)",
        term: search_term
      )
    end

    # Total count for counters and pagination calculations
    @total_users_count = @users.count
    @page = (params[:page] || 1).to_i

    # Fetch only the current batch in descending order
    @users = @users.order(created_at: :desc)
                   .limit(PER_PAGE)
                   .offset((@page - 1) * PER_PAGE)

    @has_next_page = (@page * PER_PAGE) < @total_users_count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  private

  def user_params
    params.require(:user).permit(:name, :role, :email)
  end
end