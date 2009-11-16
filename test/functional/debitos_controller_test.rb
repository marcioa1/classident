require 'test_helper'

class DebitosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:debitos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create debito" do
    assert_difference('Debito.count') do
      post :create, :debito => { }
    end

    assert_redirected_to debito_path(assigns(:debito))
  end

  test "should show debito" do
    get :show, :id => debitos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => debitos(:one).to_param
    assert_response :success
  end

  test "should update debito" do
    put :update, :id => debitos(:one).to_param, :debito => { }
    assert_redirected_to debito_path(assigns(:debito))
  end

  test "should destroy debito" do
    assert_difference('Debito.count', -1) do
      delete :destroy, :id => debitos(:one).to_param
    end

    assert_redirected_to debitos_path
  end
end
