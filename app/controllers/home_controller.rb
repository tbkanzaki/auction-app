class HomeController < ApplicationController
  def index
    @approved_in_progress_lots = Lot.approved.where("start_date <= ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
    @approved_future_lots = Lot.approved.where("start_date > ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
  end
end
