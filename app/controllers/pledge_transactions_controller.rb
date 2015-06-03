class PledgeTransactionsController < ApplicationController


  def new
    @pledge = PledgeTransaction.new
  end

  def create
    @pledge = PledgeTransaction.new(pledge_params)
    if @pledge.save
      render 'success'
    else
      render 'fail'
    end
  end

  private
  def pledge_params
    params.require(:pledge_transaction).permit(
      :amount,
      :user_id,
      :project_id,
      :currency_id,
      :transaction_id,
      :email
    )
  end
end
