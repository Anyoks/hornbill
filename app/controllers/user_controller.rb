class UserController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    data = []
    lables = User.group_by_month(:created_at).count
    @data = {
      labels: lables.map {|label, data| label.strftime("%B") },
      datasets: [
        {
           # label: "My First dataset",
           # pointStrokeColor: "#FFA500",
           # fillColor: "rgba(255,165,0,0.5)",
           # pointColor: "rgba(255,165,0,1)",
           # strokeColor: "rgba(255,165,0,1)",
           data: lables.map {|label, data| data  },
           backgroundColor: "#FF6384",
           hoverBackgroundColor: "#FF6384"

        }
      ]
    }
    @options = {:height => "253", :width => "507"}
    # byebug

    @data2 = {
      labels: lables.map {|label, data| label.strftime("%B") },
      datasets: [
        {
           label: "My First dataset",
           pointStrokeColor: "#FFA500",
           fillColor: "rgba(255,165,0,0.5)",
           pointColor: "rgba(255,165,0,1)",
           strokeColor: "rgba(255,165,0,1)",
           data: lables.map {|label, data| data  },
           # backgroundColor: "#FF6384",
           # hoverBackgroundColor: "#FF6384"

        }
      ]
    }
    @options1 = {:height => "253", :width => "507"}
    @options2 = {:height => "253", :width => "507"}
    @options3 = {:height => "253", :width => "507"}
    @options4 = {:height => "253", :width => "507"}
    @options5 = {:height => "253", :width => "507"}
    # byebug
  end

  # GET /users/1
  # GET /users/1.json
  def show
    byebug
    @user = User.friendly.find(params[:id])

    @twitter_username = request.env["omniauth.auth"]["info"]["nickname"]
    @user_name = request.env["omniauth.auth"]["info"]["name"]
    @twitter_avatar_url = request.env["omniauth.auth"]["info"]["image"]

    @oauth_token = request.env["omniauth.auth"]["extra"]["access_token"].params[:oauth_token]
    @oauth_token_secret = request.env["omniauth.auth"]["extra"]["access_token"].params[:oauth_token_secret]

    @timeline = Timeline.new(@oauth_token, @oauth_token_secret)

    @url_objs = @timeline.make_url_objs
    @max_appearances = @timeline.get_max_appearances(@url_objs)
    byebug
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.friendly.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def make_moderator
    @user = User.find(params[:user_id])
    @user.make_moderator
    respond_to do |format|
      format.html { redirect_to user_index_path, notice:  " #{@user.first_name} is now a Moderator." }
      format.json { head :no_content }
    end
  end
  def make_normal_user
    @user = User.find(params[:user_id])
    @user.make_normal_user
    respond_to do |format|
      format.html { redirect_to user_index_path, notice:  " #{@user.first_name} is now a Normal User." }
      format.json { head :no_content }
    end
  end



  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_index_path, notice:  " #{@user.first_name} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      byebug
      params.require(:user).permit(:avatar)
    end
end
