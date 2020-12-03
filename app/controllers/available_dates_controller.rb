class AvailableDatesController < ApplicationController

  def index 

    days = 2

    date = Time.now + 1.days
    dates = []

    days.times do 
      dates.push ({:date => date, id: date.to_time.to_i})
      date = date + 1.days
    end
      render json: dates, status: :ok
  end
end

