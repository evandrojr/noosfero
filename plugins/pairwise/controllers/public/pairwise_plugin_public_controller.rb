class PairwisePluginPublicController < PublicController
  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  #before_filter :login_required, :only => :select_community

  def index
    question_id = params[:id]
    client = PairwiseClient.new params[:profile_id]
    question = client.question_with_prompt(question_id, visitor_id)

    render :index
  end

  def results
    question_id = params[:id]
    client = PairwiseClient.new params[:profile_id]
  end

  def vote
    question_id = paarms[:id]
    client = PairwiseClient.new params[:profile_id]
    redirect_to :index
  end
end
