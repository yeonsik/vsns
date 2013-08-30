class UsersController < ApplicationController
  layout "two_columns"

  def like 
    @user = User.find(params[:id])
    @item = Item.find(params[:item_id])
    @user.like! @item

    respond_to do |format|
      format.js
    end

  end

  def dislike
    @user = User.find(params[:id])
    @item = Item.find(params[:item_id])
    @user.dislike! @item

    respond_to do |format|
      format.js
    end
  end

  def followings
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followings.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def follow
    @user = User.find(params[:id])
    @other_user = User.find(params[:other_id])
    @user.follow! @other_user
    respond_to do | format |
      format.js
    end
  end

  def unfollow
    @user = User.find(params[:id])
    @other_user = User.find(params[:other_id])
    @user.unfollow! @other_user
    respond_to do | format |
      format.js
    end
  end

end