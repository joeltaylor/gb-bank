module ApplicationHelper
  def page_specific_css_id
    "#{params[:controller]}-#{params[:action]}".tr("_", "-")
  end
end
