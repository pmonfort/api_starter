# frozen_string_literal: true

require './api/base_controller'

module API
  Company controller
  class CompanyController < BaseController
    get '/companies/:id' do
      company
    end

    post '/companies', allows: %i[web_site], needs: %i[name] do
      if company.update(company_params)
        status 201
        { message: 'Company was successfully created.' }
      else
        halt 500, json({ message: company.errors.full_messages })
      end
    end

    put '/companies/:id', allows: %i[name web_site] do
      if company.update(company_params)
        { message: 'Company was successfully updated.' }
      else
        halt 500, json({ message: company.errors.full_messages })
      end
    end

    def company
      @company ||= Company.find(params[:id])
    end
  end
end
