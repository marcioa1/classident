require 'test_helper'

class AbonosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:abonos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create abono" do
    assert_difference('Abono.count') do
      post :create, :abono => { }
    end

    assert_redirected_to abono_path(assigns(:abono))
  end

  test "should show abono" do
    get :show, :id => abonos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => abonos(:one).to_param
    assert_response :success
  end

  test "should update abono" do
    put :update, :id => abonos(:one).to_param, :abono => { }
    assert_redirected_to abono_path(assigns(:abono))
  end

  test "should destroy abono" do
    assert_difference('Abono.count', -1) do
      delete :destroy, :id => abonos(:one).to_param
    end

    assert_redirected_to abonos_path
  end
end
