module BootstrapHelper
  def bs_icon(type)
    span_string = "<span class=\"glyphicon glyphicon-#{type}\" aria-hidden=\"true\"></span>"
    raw(span_string)
  end
end
