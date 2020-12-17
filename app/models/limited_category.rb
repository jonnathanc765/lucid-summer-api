class LimitedCategory < Category
  include Rails.application.routes.url_helpers
  attribute :limited_products

  def limited_products 
    products = self.products.limit(10)

    products = products.map do | product | 
      product.as_json.merge(
        images: product.images.map { 
          |image| { id: image.id, url: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: false) } 
        } 
      ) 
    end
    
    products
  end

end
