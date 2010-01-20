require 'test_helper'

class TrabalhoProteticosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trabalho_proteticos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create trabalho_protetico" do
    assert_difference('TrabalhoProtetico.count') do
      post :create, :trabalho_protetico => { }
    end

    assert_redirected_to trabalho_protetico_path(assigns(:trabalho_protetico))
  end

  test "should show trabalho_protetico" do
    get :show, :id => trabalho_proteticos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => trabalho_proteticos(:one).to_param
    assert_response :success
  end

  test "should update trabalho_protetico" do
    put :update, :id => trabalho_proteticos(:one).to_param, :trabalho_protetico => { }
    assert_redirected_to trabalho_protetico_path(assigns(:trabalho_protetico))
  end

  test "should destroy trabalho_protetico" do
    assert_difference('TrabalhoProtetico.count', -1) do
      delete :destroy, :id => trabalho_proteticos(:one).to_param
    end

    assert_redirected_to trabalho_proteticos_path
  end
end
