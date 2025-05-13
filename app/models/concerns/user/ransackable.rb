module User::Ransackable
  extend ActiveSupport::Concern
  class_methods do 
    def ransackable_attributes(auth_object = nil) 
      #filtering by name only
      ["name"]
    end
  end
end
