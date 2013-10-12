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

  def flash_messages
    render :partial => 'shared/flash_messages'
  end

  def is_active_controller?(controller_name)
    params[:controller] == controller_name
  end

  def is_active_action?(action_name)
    params[:action] == action_name
  end

  def is_active_page?(page_name)
    params[:controller] == 'pages' && params[:action] == 'show' && params[:id] == page_name
  end
end
