require 'will_paginate/array'

class PairwisePluginSuggestionsController < ProfileController

  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

  before_filter :load_pairwise_question

  def index
    return no_result if @pairwise_content.nil?
    return no_result if @pairwise_content.question.nil?
    @choices = list_choices
    @choices = WillPaginate::Collection.create(params[:page] || 1, 20, @choices.length) do |pager|
      pager.replace(@choices.slice(pager.offset, pager.per_page))
    end
  end

  def edit
    return no_result if @pairwise_content.nil?
    return no_result if @pairwise_content.question.nil?
    @choice = @pairwise_content.find_choice params[:choice_id]
  end

  def update
    return no_result if @pairwise_content.nil?
    if @pairwise_content.update_choice(params[:choice][:id], params[:choice][:data], params[:choice][:active])
      redirect_to :action => :index, :id => @pairwise_content.id, :pending => params[:pending]
    else
      @choice = @pairwise_content.find_choice params[:choice][:id]
      @choice.data = params[:choice][:data]
      flash[:error] = @pairwise_content.errors.full_messages
      render :edit
    end
  end

  def approve
    return no_result if @pairwise_content.nil?
    if @pairwise_content.approve_choice(params[:choice_id])
      redirect_to :action => :index, :id => @pairwise_content.id, :page => params[:page], :pending => params[:pending]
    else
      flash[:error] = @pairwise_content.errors.full_messages
      redirect_to :action => :index, :id => @pairwise_content.id, :page => params[:page], :pending => params[:pending]
    end
  end

  def inactivate
    return no_result if @pairwise_content.nil?
    @pairwise_content.inactivate(params[:choice_id])
    redirect_to :action => :index, :id => @pairwise_content.id, :page => params[:page], :pending => params[:pending]
  end

  def reprove
    return no_result if @pairwise_content.nil?
    @pairwise_content.flag_choice(params[:choice_id])
    redirect_to :action => :index, :id => @pairwise_content.id, :page => params[:page], :pending => params[:pending]
  end

private

  def list_choices
    if '1'.eql?(params[:pending])
      if '1'.eql?(params[:reproved])
        @pairwise_content.reproved_choices(params[:filter], params[:order])
      else
        @pairwise_content.pending_choices(params[:filter], params[:order])
      end
    else
      @pairwise_content.raw_choices(params[:filter], params[:order])
    end
  end

  def no_result
    render :no_result
  end

  def load_pairwise_question
    @pairwise_content ||= profile.articles.find(params[:id])
    render_access_denied unless @pairwise_content.allow_edit?(user)
  end
end
