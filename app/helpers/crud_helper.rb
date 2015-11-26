module CrudHelper
  # from https://coderwall.com/p/jzofog
  def flash_class(level)
    case level.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-danger'
    when :alert then 'alert alert-warning'
    else 'alert alert-info'
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def new_or_edit(resource)
    resource.persisted? ? 'Edit' : 'New'
  end

  def big_link(text, url, options = {})
    clearfix = options[:inline] ? '' : 'clearfix'
    link_to text, url, class: "btn btn-lg btn-primary #{clearfix}"
  end

  def new_link(model, options = {})
    name = model.table_name.singularize
    namespage = options[:namespace] || 'admin'
    url = options[:url] || send("new_#{namespage}_#{name}_path")
    text = options[:text] || "+ New #{name.humanize}"
    big_link(text, url)
  end

  def back_link(text, url)
    link_to raw('< &nbsp;&nbsp; ' + text), url, :class => 'btn btn-lg btn-default btn-back'
  end

  def page_header(title, &block)
    if block_given?
      block_text = capture(&block)
    else
      block_text = ''
    end
    html = '<div class="page-header">'
    html += "<h1>#{title}</h1>"
    html += block_text
    html += '</div>'
    raw(html)
  end

  def admin_submit_btn(f, options = {})
    text = options[:text] || 'Save'
    f.button :submit, text, class: 'btn btn-primary btn-lg'
  end
end
