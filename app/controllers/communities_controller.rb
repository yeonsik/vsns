class CommunitiesController < ApplicationController  

  layout "two_columns"

  def new
    @community = Community.new
  end

  def edit
    @community = Community.find(params[:id])
    @communities_joined = current_user.communities
  end

  def create  	
  	@community = Community.new(community_params)
    @community.owner = current_user    
    @community.users << current_user
	
  	respond_to do |format|
  		if @community.save		
        @communities_joined = current_user.communities if user_signed_in?
        format.html { redirect_to community_path(@community.id), notice: 'Community was successfully created.' }          
        format.js	
      else  # if validation errors occur
        format.html { render :edit, notice: @commnunity.errors }
        format.js
      end
  	end
  end  

  def update    
    @community = Community.find(params[:id]) 
    
    respond_to do |format|
      if @community.update_attributes(community_params) 
        format.html { redirect_to community_path(@community.id), notice: 'Community was successfully updated.' }  
        format.js 
      end
    end
  end 

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    respond_to do | format |
      format.js
    end
  end

  private    
    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name, :owner_id, :description)
    end

end
