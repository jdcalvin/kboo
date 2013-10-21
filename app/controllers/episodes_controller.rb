class EpisodesController < ApplicationController
  before_filter :restrict_access, :except => [:index, :show]
  
  def index
    @episodes = Episode.all
  end

  def new
    @episode = Episode.new
  end

  def create
    @episode = Episode.new(episode_params)
    if @episode.save
      respond_to do |format|
        format.html do
          flash[:success] = "Episode saved"
          redirect_to @episode
        end
        format.json do
          render :json => @episode, :status => :created
        end
      end  
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "Episode not saved"
          render 'new'
        end
        format.json do
          render :json => @episode.errors
        end
      end
    end
  end


  def show
    @episode = Episode.find(params[:id])
  end

  def edit
     
  end

  def update
    #update
  end

  def destroy
    @episode = Episode.find(params[:id])
    if @episode.destroy
      flash[:success]
      redirect_to programs_path
    else
      flash[:error]
      redirect_to programs_path
    end
  end

  private

  def episode_params
    params.require(:episode).permit(:title, :category, :short_description, :host, :url, :long_description, :audio_promo, :image)
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
end
