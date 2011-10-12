desc "Explaining what the task does"
task :enju_nii do
  Dir.glob(Rails.root.to_s + '/db/fixtures/*.yml').each do |file|
    Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
  end
end
