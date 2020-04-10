# frozen_string_literal: true

require './api/base_controller'

module API
  class CompaniesController < BaseController
    get '/companies/:id' do
      company
    end

    post '/companies' do
      required_params company: %i[name]
      company = Company.new(company_params)
      if company.save
        status 201
        { message: 'Company was successfully created.' }
      else
        halt 400, json({ message: company.errors.full_messages })
      end
    end

    put '/companies/:id' do
      if company.update(company_params)
        { message: 'Company was successfully updated.' }
      else
        halt 400, json({ message: company.errors.full_messages })
      end
    end

    def company
      @company ||= Company.find(params[:id])
    rescue
      halt 404
    end

    def product_params
      params['company'].slice(
        %w[name web_site]
      )
    end
  end
end
