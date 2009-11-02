require 'test_helper'

class TabelasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tabelas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tabela" do
    assert_difference('Tabela.count') do
      post :create, :tabela => { }
    end

    assert_redirected_to tabela_path(assigns(:tabela))
  end

  test "should show tabela" do
    get :show, :id => tabelas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tabelas(:one).to_param
    assert_response :success
  end

  test "should update tabela" do
    put :update, :id => tabelas(:one).to_param, :tabela => { }
    assert_redirected_to tabela_path(assigns(:tabela))
  end

  test "should destroy tabela" do
    assert_difference('Tabela.count', -1) do
      delete :destroy, :id => tabelas(:one).to_param
    end

    assert_redirected_to tabelas_path
  end
end
