require 'grape'

  module Noosfero;

    module API
      module APIHelpers
      PRIVATE_TOKEN_PARAM = :private_token
      DEFAULT_ALLOWED_PARAMETERS = [:parent_id, :from, :until, :content_type, :author_id]

      include SanitizeParams
      include Noosfero::Plugin::HotSpot
      include ForgotPasswordHelper
      include SearchTermHelper

      def set_locale
        I18n.locale = (params[:lang] || request.env['HTTP_ACCEPT_LANGUAGE'] || 'en')
      end

      # FIXME this filter just loads @plugins
      def init_noosfero_plugins
        plugins
      end

      def current_tmp_user
        private_token = (params[PRIVATE_TOKEN_PARAM] || headers['Private-Token']).to_s
        @current_tmp_user = Noosfero::API::CaptchaSessionStore.get(private_token)
        @current_tmp_user
      end

      def logout_tmp_user
        @current_tmp_user = nil
      end      

      def current_user
        private_token = (params[PRIVATE_TOKEN_PARAM] || headers['Private-Token']).to_s
        @current_user ||= User.find_by_private_token(private_token)
        @current_user
      end

      def current_person
        current_user.person unless current_user.nil?
      end

      def logout
        @current_user = nil
      end

      def environment
        @environment
      end

      ####################################################################
      #### SEARCH
      ####################################################################
      def find_by_contents(asset, context, scope, query, paginate_options={:page => 1}, options={})
        scope = scope.with_templates(options[:template_id]) unless options[:template_id].blank?
        search = plugins.dispatch_first(:find_by_contents, asset, scope, query, paginate_options, options)
        register_search_term(query, scope.count, search[:results].count, context, asset)
        search
      end
      def paginate_options(page = params[:page])
        page = 1 if multiple_search?(@searches) || params[:display] == 'map'
        { :per_page => limit, :page => page }
      end
      def multiple_search?(searches=nil)
        ['index', 'category_index'].include?(params[:action]) || (searches && searches.size > 1)
      end
      ####################################################################

      def logger
        logger = Logger.new(File.join(Rails.root, 'log', "#{ENV['RAILS_ENV'] || 'production'}_api.log"))
        logger.formatter = GrapeLogging::Formatters::Default.new
        logger
      end

      def limit
        limit = params[:limit].to_i
        limit = default_limit if limit <= 0
        limit
      end

      def period(from_date, until_date)
        return nil if from_date.nil? && until_date.nil?

        begin_period = from_date.nil? ? Time.at(0).to_datetime : from_date
        end_period = until_date.nil? ? DateTime.now : until_date

        begin_period..end_period
      end

      def parse_content_type(content_type)
        return nil if content_type.blank?
        content_type.split(',').map do |content_type|
          content_type.camelcase
        end
      end

      ARTICLE_TYPES = ['Article'] + Article.descendants.map{|a| a.to_s}
      TASK_TYPES = ['Task'] + Task.descendants.map{|a| a.to_s}

      def find_article(articles, id)
        article = articles.find(id)
        article.display_to?(current_person) ? article : forbidden!
      end

      def post_article(asset, params)
        return forbidden! unless current_person.can_post_content?(asset)

        klass_type= params[:content_type].nil? ? 'TinyMceArticle' : params[:content_type]
        return forbidden! unless ARTICLE_TYPES.include?(klass_type)

        article = klass_type.constantize.new(params[:article])
        article.last_changed_by = current_person
        article.created_by= current_person
        article.profile = asset

        if !article.save
          render_api_errors!(article.errors.full_messages)
        end
        present article, :with => Entities::Article, :fields => params[:fields]
      end

      def present_article(asset)
        article = find_article(asset.articles, params[:id])
        present article, :with => Entities::Article, :fields => params[:fields]
      end

      def present_articles(asset, method = 'articles')
        articles = find_articles(asset, method)
        present_articles_paginated(articles)
      end

      def present_articles_paginated(articles, per_page=nil)
        articles = paginate(articles)
        present articles, :with => Entities::Article, :fields => params[:fields]
      end

      def find_articles(asset, method = 'articles')
        articles = select_filtered_collection_of(asset, method, params)
        if current_person.present?
          articles = articles.display_filter(current_person, nil)
        else
          articles = articles.published
        end
        articles
      end

      def find_task(asset, id)
        task = asset.tasks.find(id)
        current_person.has_permission?(task.permission, asset) ? task : forbidden!
      end

      def post_task(asset, params)
        klass_type= params[:content_type].nil? ? 'Task' : params[:content_type]
        return forbidden! unless TASK_TYPES.include?(klass_type)

        task = klass_type.constantize.new(params[:task])
        task.requestor_id = current_person.id
        task.target_id = asset.id
        task.target_type = 'Profile'

        if !task.save
          render_api_errors!(task.errors.full_messages)
        end
        present task, :with => Entities::Task, :fields => params[:fields]
      end

      def present_task(asset)
        task = find_task(asset, params[:id])
        present task, :with => Entities::Task, :fields => params[:fields]
      end

      def present_tasks(asset)
        tasks = select_filtered_collection_of(asset, 'tasks', params)
        tasks = tasks.select {|t| current_person.has_permission?(t.permission, asset)}
        return forbidden! if tasks.empty? && !current_person.has_permission?(:perform_task, asset)
        present tasks, :with => Entities::Task, :fields => params[:fields]
      end

      def make_conditions_with_parameter(params = {})
        parsed_params = parser_params(params)
        conditions = {}
        from_date = DateTime.parse(parsed_params.delete(:from)) if parsed_params[:from]
        until_date = DateTime.parse(parsed_params.delete(:until)) if parsed_params[:until]

        conditions[:type] = parse_content_type(parsed_params.delete(:content_type)) unless parsed_params[:content_type].nil?

        conditions[:created_at] = period(from_date, until_date) if from_date || until_date
        conditions.merge!(parsed_params)

        conditions
      end

      # changing make_order_with_parameters to avoid sql injection
      def make_order_with_parameters(object, method, params)
        order = "created_at DESC"
        unless params[:order].blank?
          if params[:order].include? '\'' or params[:order].include? '"'
            order = "created_at DESC"
          elsif ['RANDOM()', 'RANDOM'].include? params[:order].upcase
            order = 'RANDOM()'
          else
            field_name, direction = params[:order].split(' ')
            assoc = object.class.reflect_on_association(method.to_sym)
            if !field_name.blank? and assoc
              if assoc.klass.attribute_names.include? field_name
                if direction.present? and ['ASC','DESC'].include? direction.upcase
                  order = "#{field_name} #{direction.upcase}"
                end
              end
            end
          end
        end
        return order
      end

      def make_page_number_with_parameters(params)
        params[:page] || 1
      end

      def make_per_page_with_parameters(params)
        params[:per_page] ||= limit
        params[:per_page].to_i
      end

      def make_timestamp_with_parameters_and_method(params, method)
        timestamp = nil
        if params[:timestamp]
          datetime = DateTime.parse(params[:timestamp])
          table_name = method.to_s.singularize.camelize.constantize.table_name
          timestamp = "#{table_name}.updated_at >= '#{datetime}'"
        end

        timestamp
      end

      def by_reference(scope, params)
        reference_id = params[:reference_id].to_i == 0 ? nil : params[:reference_id].to_i
        if reference_id.nil?
          scope
        else
          created_at = scope.find(reference_id).created_at
          scope.send("#{params.key?(:oldest) ? 'older_than' : 'younger_than'}", created_at)
         end
      end

      def by_categories(scope, params)
        category_ids = params[:category_ids]
        if category_ids.nil?
          scope
        else
          scope.joins(:categories).where(:categories => {:id => category_ids})
        end
      end

      def select_filtered_collection_of(object, method, params)
        conditions = make_conditions_with_parameter(params)
        order = make_order_with_parameters(object,method,params)
        page_number = make_page_number_with_parameters(params)
        per_page = make_per_page_with_parameters(params)
        timestamp = make_timestamp_with_parameters_and_method(params, method)

        objects = object.send(method)
        objects = by_reference(objects, params)
        objects = by_categories(objects, params)

        objects = objects.where(conditions).where(timestamp).page(page_number).per_page(per_page).reorder(order)

        objects
      end

      def authenticate!
        unauthorized! unless current_user
      end

      # Allows the anonymous captcha user authentication 
      # to pass the check. Used by the articles/vote to allow
      # the vote without login
      def authenticate_allow_captcha!
        unauthorized! unless current_tmp_user || current_user
      end

      # Checks the occurrences of uniqueness of attributes, each attribute must be present in the params hash
      # or a Bad Request error is invoked.
      #
      # Parameters:
      #   keys (unique) - A hash consisting of keys that must be unique
      def unique_attributes!(obj, keys)
        keys.each do |key|
          cant_be_saved_request!(key) if obj.send("find_by_#{key.to_s}", params[key])
        end
      end

      def attributes_for_keys(keys)
        attrs = {}
        keys.each do |key|
          attrs[key] = params[key] if params[key].present? or (params.has_key?(key) and params[key] == false)
        end
        attrs
      end

      ##########################################
      #              error helpers             #
      ##########################################

      def not_found!
        render_api_error!('404 Not found', 404)
      end

      def forbidden!
        render_api_error!('403 Forbidden', 403)
      end

      def cant_be_saved_request!(attribute)
        message = _("(Invalid request) #{attribute} can't be saved")
        render_api_error!(message, 400)
      end

      def bad_request!(attribute)
        message = _("(Bad request) #{attribute} not given")
        render_api_error!(message, 400)
      end

      def something_wrong!
        message = _("Something wrong happened")
        render_api_error!(message, 400)
      end

      def unauthorized!
        render_api_error!(_('Unauthorized'), 401)
      end

      def not_allowed!
        render_api_error!(_('Method Not Allowed'), 405)
      end

      # javascript_console_message is supposed to be executed as console.log()
      def render_api_error!(user_message, status, log_message = nil, javascript_console_message = nil)
        message_hash = {'message' => user_message, :code => status}
        message_hash[:javascript_console_message] = javascript_console_message if javascript_console_message.present?
        log_msg = "#{status}, User message: #{user_message}"
        log_msg = "#{log_message}, #{log_msg}" if log_message.present?
        log_msg = "#{log_msg}, Javascript Console Message: #{javascript_console_message}" if javascript_console_message.present?
        logger.error log_msg unless Rails.env.test?
        error!(message_hash, status)
      end

      def render_api_errors!(messages)
        messages = messages.to_a if messages.class == ActiveModel::Errors
        render_api_error!(messages.join(','), 400)
      end

      protected

      def set_session_cookie
        cookies['_noosfero_api_session'] = { value: @current_user.private_token, httponly: true } if @current_user.present?
        # Set also the private_token for the current_tmp_user
        cookies['_noosfero_api_session'] = { value: @current_tmp_user.private_token, httponly: true } if @current_tmp_user.present?
      end

      def setup_multitenancy
        Noosfero::MultiTenancy.setup!(request.host)
      end

      def detect_stuff_by_domain
        @domain = Domain.find_by_name(request.host)
        if @domain.nil?
          @environment = Environment.default
          if @environment.nil? && Rails.env.development?
            # This should only happen in development ...
            @environment = Environment.create!(:name => "Noosfero", :is_default => true)
          end
        else
          @environment = @domain.environment
        end
      end

      def filter_disabled_plugins_endpoints
        not_found! if Noosfero::API::API.endpoint_unavailable?(self, @environment)
      end

      private

      def parser_params(params)
        parsed_params = {}
        params.map do |k,v|
          parsed_params[k.to_sym] = v if DEFAULT_ALLOWED_PARAMETERS.include?(k.to_sym)
        end
        parsed_params
      end

      def default_limit
        20
      end

      def parse_content_type(content_type)
        return nil if content_type.blank?
        content_type.split(',').map do |content_type|
          content_type.camelcase
        end
      end

      def period(from_date, until_date)
        begin_period = from_date.nil? ? Time.at(0).to_datetime : from_date
        end_period = until_date.nil? ? DateTime.now : until_date
        begin_period..end_period
      end

      ##########################################
      #              captcha_helpers           #
      ##########################################

      def test_captcha(remote_ip, params, environment)
        d = environment.api_captcha_settings
        return true unless d[:enabled] == true
        msg_icve = _('Internal captcha validation error')
        msg_eacs = 'Environment api_captcha_settings'
        s = 500

        if d[:provider] == 'google'
          return render_api_error!(msg_icve, s, nil, "#{msg_eacs} private_key not defined") if d[:private_key].nil?
          return render_api_error!(msg_icve, s, nil, "#{msg_eacs} version not defined") unless d[:version] == 1 || d[:version] == 2
          if d[:version]  == 1
            d[:verify_uri] ||= 'https://www.google.com/recaptcha/api/verify'
            return verify_recaptcha_v1(remote_ip, d[:private_key], d[:verify_uri], params[:recaptcha_challenge_field], params[:recaptcha_response_field])
          end
          if d[:version] == 2
            d[:verify_uri] ||= 'https://www.google.com/recaptcha/api/siteverify'
            return verify_recaptcha_v2(remote_ip, d[:private_key], d[:verify_uri], params[:g_recaptcha_response])
          end
        end
        if d[:provider] == 'serpro'
          return render_api_error!(msg_icve, s, nil, "#{msg_eacs} verify_uri not defined") if d[:verify_uri].nil?
          return verify_serpro_captcha(d[:serpro_client_id], params[:txtToken_captcha_serpro_gov_br], params[:captcha_text], d[:verify_uri])
        end
        return render_api_error!(msg_icve, s, nil, "#{msg_eacs} provider not defined")
      end

      def verify_recaptcha_v1(remote_ip, private_key, api_recaptcha_verify_uri, recaptcha_challenge_field, recaptcha_response_field)
        if recaptcha_challenge_field == nil || recaptcha_response_field == nil
          return render_api_error!(_('Captcha validation error'), 500, nil, _('Missing captcha data'))
        end

        verify_hash = {
            "privatekey"  => private_key,
            "remoteip"    => remote_ip,
            "challenge"   => recaptcha_challenge_field,
            "response"    => recaptcha_response_field
        }
        uri = URI(api_recaptcha_verify_uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(verify_hash)
        begin
          result = https.request(request).body.split("\n")
        rescue Exception => e
          return render_api_error!(_('Internal captcha validation error'), 500, nil, "Error validating Googles' recaptcha version 1: #{e.message}")
        end
        return true if result[0] == "true"
        return render_api_error!(_("Wrong captcha text, please try again"), 403, nil, "Error validating Googles' recaptcha version 1: #{result[1]}") if result[1] == "incorrect-captcha-sol"
        #Catches all errors at the end
        return render_api_error!(_("Internal recaptcha validation error"), 500, nil, "Error validating Googles' recaptcha version 1: #{result[1]}")
      end

      def verify_recaptcha_v2(remote_ip, private_key, api_recaptcha_verify_uri, g_recaptcha_response)
        return render_api_error!(_('Captcha validation error'), 500, nil, _('Missing captcha data')) if g_recaptcha_response == nil
        verify_hash = {
            "secret"    => private_key,
            "remoteip"  => remote_ip,
            "response"  => g_recaptcha_response
        }
        uri = URI(api_recaptcha_verify_uri)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(verify_hash)
        begin
          body = https.request(request).body
        rescue Exception => e
          return render_api_error!(_('Internal captcha validation error'), 500, nil, "recaptcha error: #{e.message}")
        end
        captcha_result = JSON.parse(body)
        captcha_result["success"] ? true : captcha_result
      end

      def verify_serpro_captcha(client_id, token, captcha_text, verify_uri)
        return render_api_error!(_("Error processing token validation"), 500, nil, "Missing Serpro's Captcha token") unless token
        return render_api_error!(_('Captcha text has not been filled'), 403) unless captcha_text
        uri = URI(verify_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.path)
        verify_string = "#{client_id}&#{token}&#{captcha_text}"
        request.body = verify_string
        begin
          body = http.request(request).body
        rescue Exception => e
          return render_api_error!(_('Internal captcha validation error'), 500, nil, "Serpro captcha error: #{e.message}")
        end
        return true if body == '1'
        return render_api_error!(_("Internal captcha validation error"), 500, body, "Unable to reach Serpro's Captcha validation service") if body == "Activity timed out"
        return render_api_error!(_("Wrong captcha text, please try again"), 403) if body == 0
        return render_api_error!(_("Serpro's captcha token not found"), 500) if body == 2
        return render_api_error!(_("No data sent to validation server or other serious problem"), 500) if body == -1
        #Catches all errors at the end
        return render_api_error!(_("Internal captcha validation error"), 500, nil, "Error validating Serpro's captcha #{body}")
      end

    end
  end
end
