module JsonApiHelpers
    def payload
        JSON.parse(response.body)
    end

    def payload_data 
        JSON.parse(response.body["data"])
    end
end