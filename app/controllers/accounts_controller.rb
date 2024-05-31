require 'httparty'

class AccountsController < ApplicationController
  include HTTParty
  before_action :set_account, only: %i[show edit update destroy]
  
  def index
    @accounts = Account.all
  end
  
  def show
   @account= Account.find(params[:id])
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
    vat = params[:vat]
    country_code = vat[0, 2]
    vat_number = vat[2..-1]

    response = HTTParty.post(
      'https://ec.europa.eu/taxation_customs/vies/rest-api/check-vat-number',
      body: {
        countryCode: country_code,
        vatNumber: vat_number
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )

    if response.success?    
        
      parsed_response = JSON.parse(response.body)

      if parsed_response['valid']          
        # Use regular expressions to extract address, zip code, and city
        address_match = parsed_response['address'].match(/^(.*?)\s+(\d{5})\s+-\s+(.*)$/)
        if address_match
          address = address_match[1].strip
          zip_code = address_match[2].strip
          city = address_match[3].strip

          result = {
            name: parsed_response['name'],
            address: address,
            zip_code: zip_code,
            city: city
          }

          render json: result
       else         
         render json: { error: 'Failed to parse address' }, status: :unprocessable_entity
       end

      else
        render json: { error: 'Invalid VAT number'}, status: :unprocessable_entity
      end
    else
      render json: { error: 'Failed to check VAT number' }, status: :bad_request
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
