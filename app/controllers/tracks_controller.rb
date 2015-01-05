class TracksController < ApplicationController
  before_action :authenticate_user!
  def index
    @tracks = Track.all
  end

  def new
    if current_user
      @track = Track.new
    else
      redirect_to root_path
    end
  end

  def upload
    begin
        $s3.buckets.first.objects.create(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, 'dbc-stereogram', :access => :public_read)
        redirect_to tracks_path
    rescue
        render :text => "Couldn't complete the upload"
    end
  end

  def create

    respond_to do |format|
      format.js{
        params[:tracks].each do |key, track_data|
        track = current_user.tracks.find_or_create_by(
          source_id: track_data['id'],
          permalink_url: track_data['permalink_url'],
          artwork_url: track_data['artwork_url'],
          description: track_data['description'],
          duration: track_data['duration'],
          waveform_url: track_data['waveform_url'],
          bpm: track_data['bpm']
          )
        next unless track.save
      end
      render plain: 'AJAX OK'
      }

      format.html {
        @track = current_user.tracks.new(track_params)
        if @track.save
          redirect_to track_path @track
        else
          redirect_to new_track_path
        end
      }
    end
  end

  def show
    @track = Track.find params[:id]
  end

  def destroy
    if (params[:song])
      $s3.buckets.first.objects.find(params[:song], BUCKET).delete
      redirect_to root_path
    else
      render :text => "No song was found to delete!"
    end
  end

  private
    def track_params
      params.require(:track).permit(:source_id, :permalink_url, :artwork_url, :description, :duration, :waveform_url, :bpm)
    end

    def sanitize_filename(file_name)
      just_filename = File.basename(file_name)
      just_filename.sub(/[^\w\.\-]/,'_')
    end
end