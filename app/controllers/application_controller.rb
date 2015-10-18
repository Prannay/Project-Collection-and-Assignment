class ApplicationController < ActionController::Base
        ############################################################
        # begin `Enable CAS`

        # Configuration
        #       - CAS_ENABLED   : If you would like to disable CAS, you can make CAS_ENABLED false
        #       - CAS_WHITE_LIST: All webpages that will not be protected by CAS
        CAS_ENABLED     = true
        CAS_WHITE_LIST  = ["static_pages"]

        if CAS_ENABLED
                before_filter CASClient::Frameworks::Rails::Filter, :unless => :skip_login?
        end

        # determine if the controller is unprotected by CAS
        protected
        def skip_login?
                CAS_WHITE_LIST.include? params[:controller]
        end

        # end `Enable CAS`
        ############################################################


        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception

        include SessionsHelper
end
