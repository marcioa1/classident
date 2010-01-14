require 'test_helper'

class TabelaProteticosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tabela_proteticos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tabela_protetico" do
    assert_difference('TabelaProtetico.count') do
      post :create, :tabela_protetico => { }
    end

    assert_redirected_to tabela_protetico_path(assigns(:tabela_protetico))
  end

  test "should show tabela_protetico" do
    get :show, :id => tabela_proteticos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tabela_proteticos(:one).to_param
    assert_response :success
  end

  test "should update tabela_protetico" do
    put :update, :id => tabela_proteticos(:one).to_param, :tabela_protetico => { }
    assert_redirected_to tabela_protetico_path(assigns(:tabela_protetico))
  end

  test "should destroy tabela_protetico" do
    assert_difference('TabelaProtetico.count', -1) do
      delete :destroy, :id => tabela_proteticos(:one).to_param
    end

    assert_redirected_to tabela_proteticos_path
  end
end
