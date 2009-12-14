require 'test_helper'

class DestinacaosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:destinacaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create destinacao" do
    assert_difference('Destinacao.count') do
      post :create, :destinacao => { }
    end

    assert_redirected_to destinacao_path(assigns(:destinacao))
  end

  test "should show destinacao" do
    get :show, :id => destinacaos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => destinacaos(:one).to_param
    assert_response :success
  end

  test "should update destinacao" do
    put :update, :id => destinacaos(:one).to_param, :destinacao => { }
    assert_redirected_to destinacao_path(assigns(:destinacao))
  end

  test "should destroy destinacao" do
    assert_difference('Destinacao.count', -1) do
      delete :destroy, :id => destinacaos(:one).to_param
    end

    assert_redirected_to destinacaos_path
  end
end
