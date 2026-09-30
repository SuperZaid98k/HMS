class DocumentsController < ApplicationController
  load_and_authorize_resource

  def create
    @document.uploaded_at ||= Time.current.to_s

    if @document.save
      redirect_back fallback_location: root_path, notice: 'Document attached successfully.'
    else
      redirect_back fallback_location: root_path, alert: 'Failed to attach document.'
    end
  end

  def destroy
    @document.destroy
    redirect_back fallback_location: root_path, notice: 'Document deleted.'
  end

  private

  def document_params
    params.require(:document).permit(:name, :file_url, :uploaded_at, :documentable_type, :documentable_id)
  end
end
