module ApplicationHelper

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def active_class(keyword, clz='active')
    if keyword.include? '-'
      clz if controller?(keyword.split('-')[0]) and action?(keyword.split('-')[1])
    else
      clz if controller? keyword
    end

  end

  def title_tag
    if @page_title
      title = @page_title
    else
      title = params[:controller].split('/')
    end

    if title.kind_of? Array
      title = (title.map {|e| e.humanize}).join ' » '
    end

    title = "Qomo | #{title}"

    content_tag 'title', title
  end

  def page_title(title)
    @page_title = title
  end
end
