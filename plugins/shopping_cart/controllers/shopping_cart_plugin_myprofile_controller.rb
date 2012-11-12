include ShoppingCartPlugin::CartHelper

class ShoppingCartPluginMyprofileController < MyProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  def edit
    if params[:settings]
      params[:settings][:enabled] = params[:settings][:enabled] == '1'
      params[:settings][:delivery] = params[:settings][:delivery] == '1'
      params[:settings][:delivery_price] = params[:settings][:delivery_price].to_d
      params[:settings][:free_delivery_price] = params[:settings][:free_delivery_price].to_d
    end

    @settings = Noosfero::Plugin::Settings.new(profile, ShoppingCartPlugin, params[:settings])
    if request.post?
      begin
        @settings.save!
        session[:notice] = _('Option updated successfully.')
      rescue Exception => exception
        session[:notice] = _('Option wasn\'t updated successfully.')
      end
      redirect_to :action => 'edit'
    end
  end

  def reports
    utc_string = ' 00:00:00 UTC'
    @from = params[:from] ? Time.parse(params[:from] + utc_string) : Time.now.utc.at_beginning_of_month
    @to = params[:to] ? Time.parse(params[:to] + utc_string) : Time.now.utc
    @status = !params[:filter_status].blank? ? params[:filter_status].to_i : nil

    condition = 'created_at >= ? AND created_at <= ?'
    condition_parameters = [@from, @to+1.day]
    if @status
      condition += ' AND status = ?'
      condition_parameters << @status
    end

    conditions = [condition] + condition_parameters
    @orders = profile.orders.find(:all, :conditions => conditions)

    @products = {}
    @orders.each do |order|
      order.products_list.each do |id, qp|
        @products[id] ||= ShoppingCartPlugin::LineItem.new(id, qp[:name])
        @products[id].quantity += qp[:quantity]
      end
    end
  end

  def update_order_status
    order = ShoppingCartPlugin::PurchaseOrder.find(params[:order_id].to_i)
    order.status = params[:order_status].to_i
    order.save!
    redirect_to :action => 'reports', :from => params[:context_from], :to => params[:context_to], :filter_status => params[:context_status]
  end
end
