class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  
  def index
    @accounts = Account.all
  end
  
  def show
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vat_lookup
    vat = "EL" + params[:vat].gsub(/\D/, '')
    response = HTTParty.get("http://ec.europa.eu/taxation_customs/vies/checkVatService.wsdl", query: { vat: vat })

    if response.success?
      result = response.parsed_response
      render json: result
    else
      render json: { error: 'Invalid VAT' }, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :vat, :city, :zipcode, :address)
  end
end
