require 'active_record/fixtures'
desc "create initial records for enju_nii"
namespace :enju_nii do
  task :setup => :environment do
    Dir.glob(Rails.root.to_s + '/db/fixtures/enju_nii/*.yml').each do |file|
      ActiveRecord::Fixtures.create_fixtures('db/fixtures/enju_nii', File.basename(file, '.*'))
    end
  end
end
