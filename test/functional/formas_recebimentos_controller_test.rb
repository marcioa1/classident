require 'test_helper'

class FormasRecebimentosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formas_recebimentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formas_recebimento" do
    assert_difference('FormasRecebimento.count') do
      post :create, :formas_recebimento => { }
    end

    assert_redirected_to formas_recebimento_path(assigns(:formas_recebimento))
  end

  test "should show formas_recebimento" do
    get :show, :id => formas_recebimentos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => formas_recebimentos(:one).to_param
    assert_response :success
  end

  test "should update formas_recebimento" do
    put :update, :id => formas_recebimentos(:one).to_param, :formas_recebimento => { }
    assert_redirected_to formas_recebimento_path(assigns(:formas_recebimento))
  end

  test "should destroy formas_recebimento" do
    assert_difference('FormasRecebimento.count', -1) do
      delete :destroy, :id => formas_recebimentos(:one).to_param
    end

    assert_redirected_to formas_recebimentos_path
  end
end
