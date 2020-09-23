class Category < ApplicationRecord
    before_save :default_values
    has_many :products, dependent: :nullify
    
    
    def default_values 
        self.color ||= '#FFFFFF'
    end

    validates :name, presence: true
end
