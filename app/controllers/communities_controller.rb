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

    # associate = Associate.new(:user => current_user, :community => @community)	
    # Community와 User 모델과의 관계선언을 이용하면 아래와 같이 간단하기 코딩할 수 있습니다. hschoi
    @community.users << current_user
	
  	respond_to do |format|
      # if @community.save && associate.save    
      # @commnity.save 시에 위에서 할당한 모든 것이 자동으로 저장되기 때문에 associate.save 는 불필요하게 됩니다.
  		if @community.save		
        format.html { redirect_to community_path(@community.id), notice: 'Community was successfully created.' }  
        # ajax 로 생성되기 때문에 format.html은 필요없죠.
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
