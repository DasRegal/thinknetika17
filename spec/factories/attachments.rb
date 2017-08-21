FactoryGirl.define do
  factory :attachment do
    file "MyString"
  end

  factory :question_attach, class: "Attachment" do 
    association :attachmentable, factory: :attachment
  end
end
