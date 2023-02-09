require 'test_helper'

class PuppiesControllerTest < ActionController::TestCase
  setup do
    @puppy = puppies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:puppies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create puppy" do
    assert_difference('Puppy.count') do
      post :create, puppy: { PUPPY_AGE: @puppy.PUPPY_AGE, PUPPY_BREED: @puppy.PUPPY_BREED, PUPPY_FUN_FACT: @puppy.PUPPY_FUN_FACT, PUPPY_NAME: @puppy.PUPPY_NAME, PUPPY_PIC: @puppy.PUPPY_PIC, PUPPY_SEX: @puppy.PUPPY_SEX, SCORE_PENALTIES: @puppy.SCORE_PENALTIES, SCORE_TACKLES: @puppy.SCORE_TACKLES, SCORE_TAKEAWAYS: @puppy.SCORE_TAKEAWAYS, SCORE_TOUCHDOWNS: @puppy.SCORE_TOUCHDOWNS, TEAM_ID: @puppy.TEAM_ID }
    end

    assert_redirected_to puppy_path(assigns(:puppy))
  end

  test "should show puppy" do
    get :show, id: @puppy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @puppy
    assert_response :success
  end

  test "should update puppy" do
    patch :update, id: @puppy, puppy: { PUPPY_AGE: @puppy.PUPPY_AGE, PUPPY_BREED: @puppy.PUPPY_BREED, PUPPY_FUN_FACT: @puppy.PUPPY_FUN_FACT, PUPPY_NAME: @puppy.PUPPY_NAME, PUPPY_PIC: @puppy.PUPPY_PIC, PUPPY_SEX: @puppy.PUPPY_SEX, SCORE_PENALTIES: @puppy.SCORE_PENALTIES, SCORE_TACKLES: @puppy.SCORE_TACKLES, SCORE_TAKEAWAYS: @puppy.SCORE_TAKEAWAYS, SCORE_TOUCHDOWNS: @puppy.SCORE_TOUCHDOWNS, TEAM_ID: @puppy.TEAM_ID }
    assert_redirected_to puppy_path(assigns(:puppy))
  end

  test "should destroy puppy" do
    assert_difference('Puppy.count', -1) do
      delete :destroy, id: @puppy
    end

    assert_redirected_to puppies_path
  end
end
