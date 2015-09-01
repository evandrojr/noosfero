class ApiDocsController < ApplicationController
  layout :api_layout

  private
    def api_layout
      params[:controller]
    end
end
