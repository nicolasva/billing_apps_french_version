require 'test_helper'

class PvrecettesControllerTest < ActionController::TestCase
  setup do
    @pvrecette = pvrecettes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pvrecettes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pvrecette" do
    assert_difference('Pvrecette.count') do
      post :create, :pvrecette => @pvrecette.attributes
    end

    assert_redirected_to pvrecette_path(assigns(:pvrecette))
  end

  test "should show pvrecette" do
    get :show, :id => @pvrecette.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @pvrecette.to_param
    assert_response :success
  end

  test "should update pvrecette" do
    put :update, :id => @pvrecette.to_param, :pvrecette => @pvrecette.attributes
    assert_redirected_to pvrecette_path(assigns(:pvrecette))
  end

  test "should destroy pvrecette" do
    assert_difference('Pvrecette.count', -1) do
      delete :destroy, :id => @pvrecette.to_param
    end

    assert_redirected_to pvrecettes_path
  end
end
