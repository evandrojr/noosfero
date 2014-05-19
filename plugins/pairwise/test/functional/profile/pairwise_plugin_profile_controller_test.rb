require 'test_helper'

require "#{Rails.root}/plugins/pairwise/test/fixtures/pairwise_content_fixtures"

class PairwisePluginProfileControllerTest < ActionController::TestCase

  def pairwise_env_settings
    { :api_host => "http://localhost:3030/",
      :username => "abner.oliveira@serpro.gov.br",
      :password => "serpro"
    }
  end

  def setup
    @environment = Environment.default
  
    @pairwise_client = Pairwise::Client.build(1, pairwise_env_settings)
    @controller = PairwisePluginProfileController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
   
    @profile = fast_create(Community, :environment_id => @environment.id)
    @question = PairwiseContentFixtures.pairwise_question_with_prompt
    @user = create_user('testinguser').person
    @profile.add_admin(@user)
    @content =  PairwiseContentFixtures.pairwise_content

    @content.expects(:new_record?).returns(true).at_least_once
    @content.expects(:valid?).returns(true).at_least_once
    @content.expects(:send_question_to_service).returns(true).at_least_once
    @profile.articles << @content
  end

  should 'get a first prompt' do
    login_as(@user.user.login)
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    @content.expects(:question_with_prompt_for_visitor).with(@user.identifier, nil).returns(@question)
    get :prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id
    assert_not_nil  assigns(:pairwise_content)
    assert_match /#{@question.name}/, @response.body
    assert_match /#{@question.prompt.left_choice_text}/, @response.body
    assert_match /#{@question.prompt.right_choice_text}/, @response.body
  end

  should 'get a prompt by a prompt id' do
    login_as(@user.user.login)
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    @content.expects(:question_with_prompt_for_visitor).with(@user.identifier, @question.prompt.id.to_s).returns(@question)
    get :prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id

    assert_not_nil  assigns(:pairwise_content)

    assert_match /#{@question.name}/, @response.body
    assert_match /#{@question.prompt.left_choice_text}/, @response.body
    assert_match /#{@question.prompt.right_choice_text}/, @response.body
  end

  should 'register a vote' do
    login_as(@user.user.login)
    #next prompt will have id = 33
    next_prompt_id = 33
    vote = { 
                'prompt' => {
                        "id" => next_prompt_id,
                        "left_choice_id" => 3,
                        "left_choice_test" => "Option 3",
                        "right_choice_id" => 4,
                        "right_choice_text" => "Option 4"
              }
            }
    @content.expects(:vote_to).with(@question.prompt.id.to_s, 'left', @user.identifier, @question.appearance_id).returns(vote).at_least_once
    #@content.expects(:question_with_prompt_for_visitor).with(@user.identifier, nil).returns(@question).at_least_once

    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content).at_least_once
    
    get :choose, 
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id,
                  :appearance_id => @question.appearance_id,
                  :direction => 'left'
    assert_response :redirect
    assert_redirected_to @content.url
  end

  should 'show new ideas elements when new ideas were allowed' do
    login_as(@user.user.login)
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    get :prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id
    assert_not_nil  assigns(:pairwise_content)

    assert_select "div[class='suggestion_form']", 1
    assert_select "div#suggestions_box", 1
  end

  should 'not show new ideas elements when new ideas were not allowed' do
    login_as(@user.user.login)
    @content.allow_new_ideas = false
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content)
    get :prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id
    assert_not_nil  assigns(:pairwise_content)

    assert_select "div[class='suggestion_form']", 0
    assert_select "div#suggestions_box", 0
  end

  should 'skip prompt' do
    login_as @user.user.login
    next_prompt_id = 33
    next_prompt = { 
                'prompt' => {
                        "id" => next_prompt_id,
                        "left_choice_id" => 3,
                        "left_choice_test" => "Option 3",
                        "right_choice_id" => 4,
                        "right_choice_text" => "Option 4"
              }
            }
    @content.expects(:skip_prompt).with(@question.prompt.id.to_s, @user.identifier, @question.appearance_id, 'some reason').returns(next_prompt).at_least_once
    #@content.expects(:question_with_prompt_for_visitor).with(@user.identifier, nil).returns(@question).at_least_once

    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content).at_least_once
    get :skip_prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id,
                  :appearance_id => @question.appearance_id,
                  :reason => 'some reason'
    assert_not_nil  assigns(:pairwise_content)

    assert_response :redirect
    assert_redirected_to @content.url
  end

  should 'fail to skip prompt if prompt_id param is missing' do
    login_as @user.user.login
    next_prompt_id = 33
    next_prompt = { 
                'prompt' => {
                        "id" => next_prompt_id,
                        "left_choice_id" => 3,
                        "left_choice_test" => "Option 3",
                        "right_choice_id" => 4,
                        "right_choice_text" => "Option 4"
              }
            }
    exception = assert_raises RuntimeError do            
      get :skip_prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :appearance_id => @question.appearance_id,
                  :reason => 'some reason'
    end
    assert_equal _("Invalid request"), exception.message
  end

  should 'fail to skip appearance_id param is missing' do
    login_as @user.user.login
    next_prompt_id = 33
    next_prompt = { 
                'prompt' => {
                        "id" => next_prompt_id,
                        "left_choice_id" => 3,
                        "left_choice_test" => "Option 3",
                        "right_choice_id" => 4,
                        "right_choice_text" => "Option 4"
              }
            }
    exception = assert_raises RuntimeError do            
      get :skip_prompt,
                  :profile => @profile.identifier,
                  :id => @content.id,
                  :question_id => @question.id,
                  :prompt_id => @question.prompt.id,
                  :reason => 'some reason'
    end
    assert_equal _("Invalid request"), exception.message
  end

  should 'show result to non logged user' do
    @question.expects(:get_choices).returns(PairwiseContentFixtures.choices_with_stats).at_least_once
    PairwisePlugin::PairwiseContent.any_instance.expects(:question).returns(@question).at_least_once
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content).at_least_once

    get :result, :profile => @profile.identifier, 
         :id => @content.id, :question_id => @question.id

    assert_select "div[class='total_votes']", 1
  end

  should 'show result to logged user' do
    login_as(@user.user.login)
    @question.expects(:get_choices).returns(PairwiseContentFixtures.choices_with_stats).at_least_once
    PairwisePlugin::PairwiseContent.any_instance.expects(:question).returns(@question).at_least_once
    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content).at_least_once

    get :result, :profile => @profile.identifier, 
         :id => @content.id, :question_id => @question.id

    assert_select "div[class='total_votes']", 1
  end

  should 'suggest new idea' do
    login_as(@user.user.login)

    PairwisePluginProfileController.any_instance.expects(:find_content).returns(@content).at_least_once
    @content.expects(:add_new_idea).returns(true).at_least_once
    
    post :suggest_idea, :id => @content.id, :profile => @profile.identifier, :idea => {:text => "NEW IDEA"}
    
    assert_redirected_to @content.url
    assert_equal "Thanks for your contributtion!", flash[:notice]
  end

  should 'not accept ideas from not logged users' do
    post :suggest_idea, :id => @content.id, :profile => @profile.identifier, :idea => {:text => "NEW IDEA"}
    assert_redirected_to @content.url
    assert_equal "Only logged user could suggest new ideas", flash[:error]
  end
end
