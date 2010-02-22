require 'test_helper'

class OrcamentosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orcamentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create orcamento" do
    assert_difference('Orcamento.count') do
      post :create, :orcamento => { }
    end

    assert_redirected_to orcamento_path(assigns(:orcamento))
  end

  test "should show orcamento" do
    get :show, :id => orcamentos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => orcamentos(:one).to_param
    assert_response :success
  end

  test "should update orcamento" do
    put :update, :id => orcamentos(:one).to_param, :orcamento => { }
    assert_redirected_to orcamento_path(assigns(:orcamento))
  end

  test "should destroy orcamento" do
    assert_difference('Orcamento.count', -1) do
      delete :destroy, :id => orcamentos(:one).to_param
    end

    assert_redirected_to orcamentos_path
  end
end
