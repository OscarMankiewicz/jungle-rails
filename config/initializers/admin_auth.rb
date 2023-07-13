Rails.application.config.middleware.use Rack::Auth::Basic, "Restricted Area" do |username, password, request|
    if request && request.path.start_with?("/admin/products")
      username == ENV["ADMIN_USERNAME"] && password == ENV["ADMIN_PASSWORD"]
    else
      true
    end
end
  
  