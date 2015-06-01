class LoansController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: Loan.where(user: user), each_serializer: LoanListSerializer
  end

  def create
    user = User.find(params[:user_id])

    loan = Loan.new(create_loan_params.merge(user: user))

    if loan.save
      render json: loan, serializer: LoanSerializer
    end
  end

  def show
    loan = Loan.find(params[:id])

    if loan.user == @current_user
      render json: loan, serializer: LoanSerializer
    else
      render json: access_denied_message, status: :unauthorized
    end
  end

  private

  def create_loan_params
    params.permit(:borrower_name, :description, :application_date)
  end
end