require 'test_helper'

class IndicacaosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:indicacaos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create indicacao" do
    assert_difference('Indicacao.count') do
      post :create, :indicacao => { }
    end

    assert_redirected_to indicacao_path(assigns(:indicacao))
  end

  test "should show indicacao" do
    get :show, :id => indicacaos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => indicacaos(:one).to_param
    assert_response :success
  end

  test "should update indicacao" do
    put :update, :id => indicacaos(:one).to_param, :indicacao => { }
    assert_redirected_to indicacao_path(assigns(:indicacao))
  end

  test "should destroy indicacao" do
    assert_difference('Indicacao.count', -1) do
      delete :destroy, :id => indicacaos(:one).to_param
    end

    assert_redirected_to indicacaos_path
  end
end
