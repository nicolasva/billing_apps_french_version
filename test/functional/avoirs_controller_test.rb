require 'test_helper'

class AvoirsControllerTest < ActionController::TestCase
  setup do
    @avoir = avoirs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:avoirs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create avoir" do
    assert_difference('Avoir.count') do
      post :create, :avoir => @avoir.attributes
    end

    assert_redirected_to avoir_path(assigns(:avoir))
  end

  test "should show avoir" do
    get :show, :id => @avoir.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @avoir.to_param
    assert_response :success
  end

  test "should update avoir" do
    put :update, :id => @avoir.to_param, :avoir => @avoir.attributes
    assert_redirected_to avoir_path(assigns(:avoir))
  end

  test "should destroy avoir" do
    assert_difference('Avoir.count', -1) do
      delete :destroy, :id => @avoir.to_param
    end

    assert_redirected_to avoirs_path
  end
end
