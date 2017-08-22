FactoryGirl.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end

  factory :question_attach, class: "Attachment" do 
    association :attachmentable, factory: :attachment
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end

  factory :answer_attach, class: "Attachment" do 
    association :attachmentable, factory: :attachment
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end
end
