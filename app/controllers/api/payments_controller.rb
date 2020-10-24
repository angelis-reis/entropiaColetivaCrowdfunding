# coding: utf-8
class Api::PaymentsController < Api::ApiController
  def update
    payment_key = params['data']['id']
    payment_status = params['data']['status']
    payment = Payment.find_by(key: payment_key)
    
    return render json: '', status: 204 if payment.blank?
    payment.pay! if payment_status == 'paid'

    render json: '', status: 200
  end
end
