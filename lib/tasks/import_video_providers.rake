require 'csv'

desc "Import Video Providers from csv file"
  task :import_video_providers => [:environment] do

  csv_text = File.read('vendor/csv/video_providers.csv')

  csv = CSV.parse(csv_text, :headers => false)

  csv.each do |row|
    VideoProvider.create!(name: row.join(","))
  end
end
