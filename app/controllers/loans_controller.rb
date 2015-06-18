class LoansController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: Loan.where(user: user), each_serializer: LoanListSerializer
  end

  def create
    user = User.find(params[:user_id])

    dates = ImportantDateService.new.create(params[:application_date])

    loan = Loan.new(create_loan_params.merge(user: user).merge(dates))

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

  def update
    loan = Loan.find(params[:id])

    dates = ImportantDateService.new.update(important_date_service_update_params)

    loan = loan.update(update_loan_params.merge(dates))

    render json: loan, serializer: LoanSerializer
  end

  private

  def create_loan_params
    params.permit(:borrower_name, :description)
  end

  def update_loan_params
    params.permit(:borrower_name, :description)
  end

  def important_date_service_update_params
    params.permit(
        :disclosures_delivered_date,
        :disclosures_received_date,
        :change_of_circumstance_date,
        :revised_disclosures_delivered_date,
        :revised_disclosures_received_date,
        :closing_disclosures_delivered_date,
        :closing_disclosures_received_date,
    )
  end
end