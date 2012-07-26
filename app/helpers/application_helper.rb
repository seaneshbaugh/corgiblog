module ApplicationHelper
  def icon_edit_link(url_or_path)
    render :partial => 'shared/icon_edit_link', :locals => { :url_or_path => build_url_or_path_for(url_or_path) }
  end

  def icon_delete_link(url_or_path)
    render :partial => 'shared/icon_delete_link', :locals => { :url_or_path => build_url_or_path_for(url_or_path) }
  end

  def build_url_or_path_for(url_or_path = '')
    url_or_path = eval(url_or_path) if url_or_path =~ /_path|_url|@/
    url_or_path
  end
end