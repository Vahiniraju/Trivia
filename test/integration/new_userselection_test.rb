require 'test_helper'

class NewUserselectionTest < ActionDispatch::IntegrationTest
  def setup
      @user = create :user
      @question = create :question
      @question2 = create :question
      @question3 = create :question
      @correct_answer = @question2.answers.where(is_correct: true).first.id
      @user_selection = { user_selection: {question_id: @question2.id, answer_id: @correct_answer, tag: "General" }}
      @user_selection1 = { user_selection: {question_id: @question.id, answer_id: @question.answers.sample.id }}
      @categories = ActsAsTaggableOn::Tag.all.collect(&:name)
      @tag =  @categories[0].to_s
  end

  test "only logged in user can get to answer the question" do
    get user_selections_path
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    post user_selections_path, params: @user_selection
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    log_in_as(@user)
    get user_selections_path
    assert_template 'user_selections/new'
    assert_select "a[href=?]", user_selections_path, count: 1
    post user_selections_path , params: @user_selection1, xhr: true
    assert_response :ok
    assert_template 'user_selections/_new'
    assert_select_jquery :html, '#user_selection_answer' do
      assert_select "a[href=?]", user_selections_path, count: 1
    end
    get tag_path(@tag)
    assert_template "user_selections/_new"
    assert_select "a[href=?]" , tag_path(@tag), count: 1
    post user_selections_path, params: @user_selection, xhr: true
    puts response.body
    assert_select_jquery :html, '#user_selection_answer' do
      assert_select "a[href=?]", tag_path(@tag), count: 1
    end
  end

end
