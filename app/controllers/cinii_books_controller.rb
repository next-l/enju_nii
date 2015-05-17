class CiniiBooksController < ApplicationController
  before_filter :authenticate
  before_filter :check_librarian

  def index
    if params[:page].to_i == 0
      page = 1
    else
      page = params[:page]
    end
    @query = params[:query].to_s.strip
    books = CiniiBook.search(params[:query], page)
    @books = Kaminari.paginate_array(
      books[:items], :total_count => books[:total_entries], :page => page
    ).page(page).per(10)

    respond_to do |format|
      format.html
    end
  end

  def create
    if params[:book]
      @manifestation = CiniiBook.import_ncid(params[:book][:ncid])
      respond_to do |format|
        if @manifestation.try(:save)
          flash[:notice] = t('controller.successfully_created', :model => t('activerecord.models.manifestation'))
          format.html { redirect_to manifestation_url(@manifestation) }
        else
          flash[:notice] = t('enju_nii.record_not_found')
          format.html { redirect_to cinii_books_url }
        end
      end
    end
  #rescue ActiveRecord::RecordInvalid => e
  #  respond_to do |format|
  #    flash[:notice] = e.message
  #    format.html { render :action => "index" }
  #  end
  end

  private
  def check_librarian
    unless current_user.try(:has_role?, 'Librarian')
      access_denied
    end
  end
end
