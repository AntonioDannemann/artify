namespace :user do
  desc "Destroy all guest accounts"
  task destroy_guests: :environment do
    User.destroy_guests
  end
end
