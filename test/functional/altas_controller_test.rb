require 'test_helper'

class AltasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:altas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create alta" do
    assert_difference('Alta.count') do
      post :create, :alta => { }
    end

    assert_redirected_to alta_path(assigns(:alta))
  end

  test "should show alta" do
    get :show, :id => altas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => altas(:one).to_param
    assert_response :success
  end

  test "should update alta" do
    put :update, :id => altas(:one).to_param, :alta => { }
    assert_redirected_to alta_path(assigns(:alta))
  end

  test "should destroy alta" do
    assert_difference('Alta.count', -1) do
      delete :destroy, :id => altas(:one).to_param
    end

    assert_redirected_to altas_path
  end
end
