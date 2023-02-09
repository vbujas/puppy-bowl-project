module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end
end
