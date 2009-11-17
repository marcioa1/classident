require 'test_helper'

class BancosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bancos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create banco" do
    assert_difference('Banco.count') do
      post :create, :banco => { }
    end

    assert_redirected_to banco_path(assigns(:banco))
  end

  test "should show banco" do
    get :show, :id => bancos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bancos(:one).to_param
    assert_response :success
  end

  test "should update banco" do
    put :update, :id => bancos(:one).to_param, :banco => { }
    assert_redirected_to banco_path(assigns(:banco))
  end

  test "should destroy banco" do
    assert_difference('Banco.count', -1) do
      delete :destroy, :id => bancos(:one).to_param
    end

    assert_redirected_to bancos_path
  end
end
