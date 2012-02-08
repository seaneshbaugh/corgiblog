module ApplicationHelper
  def image_url(source)
    root = root_url
    root[0, root.length - 1] + image_path(source)
  end

  def sortable(column, title = nil)
    title ||= column.titleize

    order = column == sort_column && sort_order == "asc" ? "desc" : "asc"

    link_to title, params.merge(:sort => column, :order => order, :page => nil)
  end

  def is_current_controller?(controller_name)
    "current" if params[:controller] == controller_name
  end

  def is_current_action?(action_name)
    "current" if params[:action] == action_name
  end
end
