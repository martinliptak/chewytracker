module ApplicationHelper
  def filtering
    params.keys.any? { |name| params[name].present? && name =~ /\Afilter_/ }
  end
end
