require 'test_helper'

class BonlivraisonsControllerTest < ActionController::TestCase
  setup do
    @bonlivraison = bonlivraisons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bonlivraisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bonlivraison" do
    assert_difference('Bonlivraison.count') do
      post :create, :bonlivraison => @bonlivraison.attributes
    end

    assert_redirected_to bonlivraison_path(assigns(:bonlivraison))
  end

  test "should show bonlivraison" do
    get :show, :id => @bonlivraison.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @bonlivraison.to_param
    assert_response :success
  end

  test "should update bonlivraison" do
    put :update, :id => @bonlivraison.to_param, :bonlivraison => @bonlivraison.attributes
    assert_redirected_to bonlivraison_path(assigns(:bonlivraison))
  end

  test "should destroy bonlivraison" do
    assert_difference('Bonlivraison.count', -1) do
      delete :destroy, :id => @bonlivraison.to_param
    end

    assert_redirected_to bonlivraisons_path
  end
end
