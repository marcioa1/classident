require 'test_helper'

class ContaBancariasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conta_bancarias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conta_bancaria" do
    assert_difference('ContaBancaria.count') do
      post :create, :conta_bancaria => { }
    end

    assert_redirected_to conta_bancaria_path(assigns(:conta_bancaria))
  end

  test "should show conta_bancaria" do
    get :show, :id => conta_bancarias(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => conta_bancarias(:one).to_param
    assert_response :success
  end

  test "should update conta_bancaria" do
    put :update, :id => conta_bancarias(:one).to_param, :conta_bancaria => { }
    assert_redirected_to conta_bancaria_path(assigns(:conta_bancaria))
  end

  test "should destroy conta_bancaria" do
    assert_difference('ContaBancaria.count', -1) do
      delete :destroy, :id => conta_bancarias(:one).to_param
    end

    assert_redirected_to conta_bancarias_path
  end
end
