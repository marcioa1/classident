require 'test_helper'

class RecebimentosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recebimentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recebimento" do
    assert_difference('Recebimento.count') do
      post :create, :recebimento => { }
    end

    assert_redirected_to recebimento_path(assigns(:recebimento))
  end

  test "should show recebimento" do
    get :show, :id => recebimentos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recebimentos(:one).to_param
    assert_response :success
  end

  test "should update recebimento" do
    put :update, :id => recebimentos(:one).to_param, :recebimento => { }
    assert_redirected_to recebimento_path(assigns(:recebimento))
  end

  test "should destroy recebimento" do
    assert_difference('Recebimento.count', -1) do
      delete :destroy, :id => recebimentos(:one).to_param
    end

    assert_redirected_to recebimentos_path
  end
end
