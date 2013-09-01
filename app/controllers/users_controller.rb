class UsersController < ApplicationController
  layout "two_columns"

  def communities
    user = User.find(params[:id])
    if current_user == user
      @other_user = nil
      @communities = current_user.communities
    else
      @other_user = user
      @communities = user.communities
    end
  end
  
  def like 
    @user = User.find(params[:id])
    @likeable = params[:likeable_type].classify.constantize.send('find', params[:likeable_id])
    @user.like! @likeable

    respond_to do |format|
      format.js
    end

  end

  def dislike
    @user = User.find(params[:id])
    @likeable = params[:likeable_type].classify.constantize.send('find', params[:likeable_id])
    @user.dislike! @likeable

    respond_to do |format|
      format.js
    end
  end

  def followings
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followings.paginate(page: params[:page])
    @communities = @user.communities
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    @communities = @user.communities
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