class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index]
  before_filter :set_communities_joined, only: [:index, :show, :edit, :new, :update, :create]

  layout 'two_columns'

  # GET /items
  # GET /items.json
  def index
    if params[:tag]
      @items = Item.tagged_with(params[:tag])
    elsif params[:community_id]
      # Community has_many :items, :through => :users
      # @items = Item.where(user_id: Community.find(params[:community_id]).users.pluck(:id))
      @items = Community.find(params[:community_id]).items
    else
      @items = Item.all
    end
    if params[:user_id]
      @other_user = User.find(params[:user_id])
      @items = @items.where( user_id: @other_user.id) 
      @communities_joined = @other_user.communities
      @other_user = nil if current_user == @other_user
    else
      @communities_joined = current_user.communities if user_signed_in?
    end
    @items = @items.order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
    if request.xhr?
      sleep(1)
      render @items
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @communities = Community.all
  end

  # GET /items/new
  def new
    @item = Item.new
    @communities = Community.all
  end

  # GET /items/1/edit
  def edit
    authorize_action_for(@item)
    @communities = Community.all
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      authorize_action_for(@item) 
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  # Mission : ajaxify the destroy action...
  def destroy
    authorize_action_for(@item) 
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
  
  # GET /items/tags
  def tags
    @tags = Item.tag_counts

    @tags = @tags.where('name LIKE ?', "%#{params[:q]}%") if params[:q]
    @tags = @tags.limit(10)

    respond_to do |format|
      format.json { render json: @tags}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:user_id, :photo, :url_ref, :description, :starts_count, :tag_list, :remote_photo_url, :remove_photo)
    end

    def set_communities_joined    
      if params[:user_id]    
        @communities_joined = User.find(params[:user_id]).communities 
      else  
        @communities_joined = current_user.communities if user_signed_in?  
      end
    end

end
