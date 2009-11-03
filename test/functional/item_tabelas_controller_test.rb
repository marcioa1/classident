require 'test_helper'

class ItemTabelasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_tabelas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_tabela" do
    assert_difference('ItemTabela.count') do
      post :create, :item_tabela => { }
    end

    assert_redirected_to item_tabela_path(assigns(:item_tabela))
  end

  test "should show item_tabela" do
    get :show, :id => item_tabelas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => item_tabelas(:one).to_param
    assert_response :success
  end

  test "should update item_tabela" do
    put :update, :id => item_tabelas(:one).to_param, :item_tabela => { }
    assert_redirected_to item_tabela_path(assigns(:item_tabela))
  end

  test "should destroy item_tabela" do
    assert_difference('ItemTabela.count', -1) do
      delete :destroy, :id => item_tabelas(:one).to_param
    end

    assert_redirected_to item_tabelas_path
  end
end
