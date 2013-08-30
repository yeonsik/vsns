class CommunitiesController < ApplicationController  

  def join
  	community = Community.find(params[:community_id])
  	associates = Associate.where :user => current_user, :community => community

  	if associates.size == 0
  		associate = Associate.create :user => current_user, :community => community
  	end

  	redirect_to community_path community
  end  

  def create  	
  	@community = Community.new(community_params)
	associate = Associate.new(:user => current_user, :community => @community)	
	
	respond_to do |format|
		if @community.save && associate.save		
			format.html { render community_url(@community.id), notice: 'Community was successfully created.' }		
	    end
	end
  end  


  private    
    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit(:name)
    end

end
