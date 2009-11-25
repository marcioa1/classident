require 'test_helper'

class ChequesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cheques)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cheque" do
    assert_difference('Cheque.count') do
      post :create, :cheque => { }
    end

    assert_redirected_to cheque_path(assigns(:cheque))
  end

  test "should show cheque" do
    get :show, :id => cheques(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cheques(:one).to_param
    assert_response :success
  end

  test "should update cheque" do
    put :update, :id => cheques(:one).to_param, :cheque => { }
    assert_redirected_to cheque_path(assigns(:cheque))
  end

  test "should destroy cheque" do
    assert_difference('Cheque.count', -1) do
      delete :destroy, :id => cheques(:one).to_param
    end

    assert_redirected_to cheques_path
  end
end
