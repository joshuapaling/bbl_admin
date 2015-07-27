module CrudHelper

  def new_or_edit(resource)
    resource.id ? 'Edit' : 'New'
  end

  def big_link(text, url)
    link_to text, url, :class => 'btn btn-lg btn-primary clearfix'
  end

  def new_link(model, options = {})
    name = model.table_name.singularize
    url = options[:url] || send("new_admin_#{name}_path")
    text = options[:text] || "+ New #{name.humanize}"
    big_link(text, url)
  end

  def td_delete(resource, options = {})
    url = options[:url] = [:admin, resource]

    if options[:disabled]
      link = ''
    else
      anchor = raw('<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>')
      link = link_to anchor, url, method: :delete,
        data: { confirm: 'Are you sure?' }
    end

    raw('<td class="delete">' + link + '</td>')
  end

  def td_edit(resource, options = {})
    name = resource.class.table_name.singularize
    url = options[:url] || send("edit_admin_#{name}_path", resource)
    link = link_to 'Edit', url
    raw('<td class="edit">' + link + '</td>')

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

  def admin_submit_btn(f)
    f.button :submit, 'Save', class: 'btn btn-primary btn-lg'
  end

end
