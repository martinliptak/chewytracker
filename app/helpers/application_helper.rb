module ApplicationHelper
  def filtering
    params.keys.any? { |name| name =~ /\Afilter_/ }
  end
end
