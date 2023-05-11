class HomeController < ApplicationController
  def index
    @lots = Lot.order(:start_date, :limit_date)
    @waiting_approval_lots = Lot.waiting_approval.order(:start_date, :limit_date)
    @approved_in_progress_lots = Lot.approved.where("start_date <= ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
    @approved_future_lots = Lot.approved.where("start_date > ? AND limit_date >= ?", Date.today, Date.today).order(:start_date, :limit_date)
  end
end