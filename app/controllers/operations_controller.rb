class OperationsController < ApplicationController
  def create
    amount = params[:amount]
    currency = params[:currency]
    external_id = params[:external_id]

    operation = Operation.find_by(external_id: external_id)
    if operation.nil?
      begin
        operation = Operation.create!(
          amount: amount,
          status: "received",
          currency: currency,
          external_id: external_id
        )
      rescue ActiveRecord::RecordNotUnique
        operation = Operation.find_by(external_id: external_id)
      end
    end

    render json: operation, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end