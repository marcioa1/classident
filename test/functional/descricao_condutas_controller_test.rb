require 'test_helper'

class DescricaoCondutasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:descricao_condutas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create descricao_conduta" do
    assert_difference('DescricaoConduta.count') do
      post :create, :descricao_conduta => { }
    end

    assert_redirected_to descricao_conduta_path(assigns(:descricao_conduta))
  end

  test "should show descricao_conduta" do
    get :show, :id => descricao_condutas(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => descricao_condutas(:one).to_param
    assert_response :success
  end

  test "should update descricao_conduta" do
    put :update, :id => descricao_condutas(:one).to_param, :descricao_conduta => { }
    assert_redirected_to descricao_conduta_path(assigns(:descricao_conduta))
  end

  test "should destroy descricao_conduta" do
    assert_difference('DescricaoConduta.count', -1) do
      delete :destroy, :id => descricao_condutas(:one).to_param
    end

    assert_redirected_to descricao_condutas_path
  end
end
