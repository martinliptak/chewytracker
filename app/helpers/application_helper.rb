module ApplicationHelper
  def bootstrap_class_for flash_type
    { notice: "alert-success", error: "alert-danger", alert: "alert-warning" }[flash_type.to_sym] || flash_type.to_s
  end
 
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)}", role: "alert") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end

  def filtering
    params.keys.any? { |name| params[name].present? && name =~ /\Afilter_/ }
  end
end
