Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "dashboard#index"
  get "/index.html" => "dashboard#index"
  get "/indexold.html" => "static#index"
  get "/index2.html" => "static#index2"
  get "/index3.html" => "static#index3"
  get "/form.html" => "static#form"
  get "/form_advanced.html" => "static#form_advanced"
  get "/tables.html" => "static#tables"
  get "/tables_dynamic.html" => "static#tables_dynamic"
  get "/general_elements.html" => "static#general_elements"
  get "/media_gallery.html" => "static#media_gallery"
  get "/typography.html" => "static#typography"
  get "/icons.html" => "static#icons"
  get "/glyphicons.html" => "static#glyphicons"
  get "/widgets.html" => "static#widgets"
  get "/invoice.html" => "static#invoice"
  get "/inbox.html" => "static#inbox"
  get "/calendar.html" => "static#calendar"
  get "/chartjs.html" => "static#chartjs"
  get "/chartjs2.html" => "static#chartjs2"
  get "/morisjs.html" => "static#morisjs"
  get "/echarts.html" => "static#echarts"
  get "/other_charts.html" => "static#other_charts"
  get "/fixed_sidebar.html" => "static#fixed_sidebar"
  get "/fixed_footer.html" => "static#fixed_footer"
  get "/kitchen_sink" => "static#kitchen_sink"
  get "/kitchen8_sink" => "static#kitchen8_sink"

  match '/jessica',      to: 'dashboard#jessica',           via: 'post'
  match '/jennifer',      to: 'dashboard#jennifer',           via: [:get, :post]
  match '/john',      to: 'dashboard#john',           via: 'post'
  match '/james',      to: 'dashboard#james',           via: 'post'
  match '/tv',      to: 'dashboard#tv',           via: 'post'
  match '/tv_volume_up',      to: 'dashboard#tv_volume_up',           via: 'post'
  match '/tv_volume_down',      to: 'dashboard#tv_volume_down',           via: 'post'
  match '/nest',      to: 'dashboard#nest',           via: 'post'
  match '/nest_temp_up',      to: 'dashboard#nest_temp_up',           via: 'post'
  match '/nest_temp_down',      to: 'dashboard#nest_temp_down',           via: 'post'
end
