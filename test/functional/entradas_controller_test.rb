require 'test_helper'

class EntradasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:entradas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create entrada" do
    assert_difference('Entrada.count') do
      post :create, :entrada => { }
    end

    assert_redirected_to entrada_path(assigns(:entrada))
  end

  test "should show entrada" do
    get :show, :id => entradas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => entradas(:one).to_param
    assert_response :success
  end

  test "should update entrada" do
    put :update, :id => entradas(:one).to_param, :entrada => { }
    assert_redirected_to entrada_path(assigns(:entrada))
  end

  test "should destroy entrada" do
    assert_difference('Entrada.count', -1) do
      delete :destroy, :id => entradas(:one).to_param
    end

    assert_redirected_to entradas_path
  end
end
