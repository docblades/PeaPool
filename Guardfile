# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^app/(.+)\.rb$})         { |m| "spec/app/#{m[1]}_spec.rb" }
end


# Possible options are :port, :executable, :pidfile, and :reload_on_change

# Default implementation - starts Redis on standard port and stops on exit
guard 'redis' do
  watch(/^(app|lib|config)\/.*\.rb$/)
  watch(/^config\/redis.yaml$/)
end

