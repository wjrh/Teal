class AiringsController < ApplicationController
  before_action :set_airing, only: [:show, :edit, :update, :destroy]

  # GET /airings
  # GET /airings.json
  def index
    @airings = Airing.all
  end

  # GET /airings/1
  # GET /airings/1.json
  def show
  end

  # GET /airings/new
  def new
    @airing = Airing.new
  end

  # GET /airings/1/edit
  def edit
  end

  # POST /airings
  # POST /airings.json
  def create
    @airing = Airing.new(airing_params)

    respond_to do |format|
      if @airing.save
        format.html { redirect_to @airing, notice: 'Airing was successfully created.' }
        format.json { render :show, status: :created, location: @airing }
      else
        format.html { render :new }
        format.json { render json: @airing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airings/1
  # PATCH/PUT /airings/1.json
  def update
    respond_to do |format|
      if @airing.update(airing_params)
        format.html { redirect_to @airing, notice: 'Airing was successfully updated.' }
        format.json { render :show, status: :ok, location: @airing }
      else
        format.html { render :edit }
        format.json { render json: @airing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airings/1
  # DELETE /airings/1.json
  def destroy
    @airing.destroy
    respond_to do |format|
      format.html { redirect_to airings_url, notice: 'Airing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_airing
      @airing = Airing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def airing_params
      params.require(:airing).permit(:start_time, :end_time, :listens)
    end
end
