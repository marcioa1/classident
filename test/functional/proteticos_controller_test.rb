require 'test_helper'

class ProteticosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proteticos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create protetico" do
    assert_difference('Protetico.count') do
      post :create, :protetico => { }
    end

    assert_redirected_to protetico_path(assigns(:protetico))
  end

  test "should show protetico" do
    get :show, :id => proteticos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proteticos(:one).to_param
    assert_response :success
  end

  test "should update protetico" do
    put :update, :id => proteticos(:one).to_param, :protetico => { }
    assert_redirected_to protetico_path(assigns(:protetico))
  end

  test "should destroy protetico" do
    assert_difference('Protetico.count', -1) do
      delete :destroy, :id => proteticos(:one).to_param
    end

    assert_redirected_to proteticos_path
  end
end
