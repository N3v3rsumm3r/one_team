class RequestsController < ApplicationController
  skip_before_action :admin_user
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :owner_admin, only: [:edit, :update, :destroy]
  before_action :collection_resources, only: [:edit, :create, :new, :update]

  # GET /requests
  # GET /requests.json
  def index
    if params.include?(:id)
      @requests = Request.open.where(user_id: params[:id])
    elsif params.include?(:active)
      @requests = Request.open
    else
      @requests = Request.all
    end
    @responses = Response.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
    @request.open = true
  end

  # GET /requests/1/edit
  def edit
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    
  
    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    
    params[:request][:skill_ids] ||= []
    
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end
  
    def collection_resources
      @projects = Project.all
      @locations = Location.all
      @departments = Department.all
      @groups = Group.all
      @users = User.all
      @skills = Skill.all
    end
  
    def owner_admin
      @request = Request.find(params[:id])
      if !owner_of?(@request) && !current_user.admin?
        flash[:danger] = "You do not have access to this action."
        redirect_to(requests_path)
      end
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:name, :description, :start_date, :end_date, :open, :project_id, :location_id, :department_id, :group_id, :user_id, :skill_ids => [])
    end
end
