class NiiTypesController < ApplicationController
  before_action :set_nii_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  # GET /nii_types
  def index
    authorize NiiType
    @nii_types = policy_scope(NiiType).order(:position)
  end

  # GET /nii_types/1
  def show
  end

  # GET /nii_types/new
  def new
    @nii_type = NiiType.new
    authorize @nii_type
  end

  # GET /nii_types/1/edit
  def edit
  end

  # POST /nii_types
  def create
    @nii_type = NiiType.new(nii_type_params)
    authorize @nii_type

    if @nii_type.save
      redirect_to @nii_type, notice:  t('controller.successfully_created', model: t('activerecord.models.nii_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /nii_types/1
  def update
    if params[:move]
      move_position(@nii_type, params[:move])
      return
    end
    if @nii_type.update(nii_type_params)
      redirect_to @nii_type, notice:  t('controller.successfully_updated', model: t('activerecord.models.nii_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /nii_types/1
  def destroy
    @nii_type.destroy
    redirect_to nii_types_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.nii_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nii_type
      @nii_type = NiiType.find(params[:id])
      authorize @nii_type
    end

    # Only allow a trusted parameter "white list" through.
    def nii_type_params
      params.require(:nii_type).permit(:name, :display_name, :note)
    end
end
