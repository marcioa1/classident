require 'test_helper'

class DentistasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dentistas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dentista" do
    assert_difference('Dentista.count') do
      post :create, :dentista => { }
    end

    assert_redirected_to dentista_path(assigns(:dentista))
  end

  test "should show dentista" do
    get :show, :id => dentistas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => dentistas(:one).to_param
    assert_response :success
  end

  test "should update dentista" do
    put :update, :id => dentistas(:one).to_param, :dentista => { }
    assert_redirected_to dentista_path(assigns(:dentista))
  end

  test "should destroy dentista" do
    assert_difference('Dentista.count', -1) do
      delete :destroy, :id => dentistas(:one).to_param
    end

    assert_redirected_to dentistas_path
  end
end
