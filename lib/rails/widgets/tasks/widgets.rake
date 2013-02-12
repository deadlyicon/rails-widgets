namespace :widgets do

  task :precompile do
    Rails::Widgets.precompile!
  end

end

namespace :assets do
  task :precompile => 'widgets:precompile'
end
