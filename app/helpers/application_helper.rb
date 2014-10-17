module ApplicationHelper


  def s2b(str)
    str == 'true' or str == true
  end


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

    content_tag :title, title
  end


  def page_title(title)
    @page_title = title
  end


  def user_tag(user)
    content_tag :a, user.full_name? ? user.full_name : user.username, href: '#'
  end


  def empty_row(collection, colspan)
    return if collection and collection.length > 0

    content_tag :tr, content_tag(:td, 'Empty', colspan: colspan), class: 'empty'
  end


  def format_timestamp(ts)
    return '' unless ts
    sec = (ts.to_f / 1000).to_s
    DateTime.strptime(sec, '%s').to_s :db
  end


end
