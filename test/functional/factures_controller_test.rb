require 'test_helper'

class FacturesControllerTest < ActionController::TestCase
  setup do
    @facture = factures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:factures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facture" do
    assert_difference('Facture.count') do
      post :create, :facture => @facture.attributes
    end

    assert_redirected_to facture_path(assigns(:facture))
  end

  test "should show facture" do
    get :show, :id => @facture.to_param
    assert_response :success
  end
  
  test "should get edit" do
    get :edit, :id => @facture.to_param
    assert_response :success
  end

  test "should update facture" do
    put :update, :id => @facture.to_param, :facture => @facture.attributes
    assert_redirected_to facture_path(assigns(:facture))
  end

  test "should destroy facture" do
    assert_difference('Facture.count', -1) do
      delete :destroy, :id => @facture.to_param
    end

    assert_redirected_to factures_path
  end
end
