module ApplicationHelper


  def render_flash_message
    {:notice => notice, :alert => alert}.each do |key, value|
      return ( content_tag(:div, content_tag(:p, value, :id => key), :class => 'flash twelve columns alpha' ) ) if value
    end
    return nil  
  end
  
end
