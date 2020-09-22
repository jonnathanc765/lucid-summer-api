class Category < ApplicationRecord
    before_save :default_values
    
    
    def default_values 
        self.color ||= '#FFFFFF'
    end

    validates :name, presence: true
end
