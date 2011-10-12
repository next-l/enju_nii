desc "copy fixtures for enju_nii"
task :enju_nii do
  Dir.glob(Rails.root.to_s + '/db/fixtures/*.yml').each do |file|
    Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
  end
end
