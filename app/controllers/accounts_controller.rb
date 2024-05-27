class AccountsController < ApplicationController
  before_action :set_account, only: %i[ show edit update destroy ]
  
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
        format.html { redirect_to account_url(@account), notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update   
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to account_url(@account), notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

    def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def vat_lookup
    vat_number = params[:vat_number]
    result = lookup_vat(vat_number)

    if result
      render json: {
        name: result[:name],
        city: result[:city],
        zipcode: result[:zipcode],
        address: result[:address]
      }
    else
      render json: { error: 'VAT lookup failed' }, status: :unprocessable_entity
    end
  end

  private    
    def set_account
      @account = Account.find(params[:id])
    end
    
    def account_params
      params.require(:account).permit(:name, :vat, :city, :zipcode, :address)
    end

    def lookup_vat(vat_number, country_code = 'GR')
      uri = URI.parse('https://ec.europa.eu/taxation_customs/vies/services/checkVatService')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
  
      soap_request = <<-REQUEST
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
          <soapenv:Header/>
          <soapenv:Body>
            <v1:checkVat>
              <countryCode>#{country_code}</countryCode>
              <vatNumber>#{vat_number}</vatNumber>
            </v1:checkVat>
          </soapenv:Body>
        </soapenv:Envelope>
      REQUEST
  
      response = http.post(uri.path, soap_request, { 'Content-Type' => 'text/xml' })
  
      if response.is_a?(Net::HTTPSuccess)
        xml_response = response.body
        company_name = xml_response.match(/<name>(.*?)<\/name>/)[1]
        company_address = xml_response.match(/<address>(.*?)<\/address>/)[1]
        # Assuming city and zipcode are part of the address parsing
        # You might need to parse them separately if available in the response
        city = company_address.split(',')[1].strip
        zipcode = company_address.split(',')[2].strip
  
        {
          name: company_name,
          city: city,
          zipcode: zipcode,
          address: company_address
        }
      else
        nil
      end
    end
end
