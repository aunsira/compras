class ShopsController < ApplicationController
  before_action :set_product, only: [:create]
  before_action :require_omise_token, only: [:create]
  before_action :check_valid_value, only: [:create]

  def new
    @token = nil
  end

  def create
    value = params[:value].to_f
    if @product
      if Rails.env.test?
        charge = OpenStruct.new({
            amount: (value * 100).to_i,
            paid: (value != 999),
        })
      else
        charge = Omise::Charge.create({
          amount: (value * 100).to_i,
          currency: "THB",
          card: params[:omise_token],
          description: "Customer has bought #{@product.name} [#{@product.id}",
        })
      end
      if charge.paid
        current_user.update_total_value(value)
        flash.notice = t('shopping.success')
        render :new
      else
        @token = nil
        flash.now.alert= t('shopping.failure')
        render :new
      end
    else
      @token = retrieve_token(params[:omise_token])
      flash.now.alert = t('shopping.failure')
      render :new
    end
  end

  private

  def retrieve_token(token)
    if Rails.env.test?
      OpenStruct.new({
          id: "tokn_X",
          card: OpenStruct.new({
            name: "aun",
            last_digits: "4242",
            expiration_month: 10,
            expiration_year: 2020,
            security_code_check: false,
         }),
       })
    else
      Omise::Token.retrieve(token)
    end
  end

  def set_product
    @product = Product.find_by(id: params[:product])
    unless @product
      @token = nil
      flash.now.alert = t('shopping.failure')
      render :new
    end
  end

  def check_valid_value
    if params[:value].blank? || params[:value].to_i <= 20
      @token = retrieve_token(params[:omise_token])
      flash.now.alert = t('shopping.failure')
      render :new
    end
  end
end