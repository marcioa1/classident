require 'test_helper'

class TipoPagamentosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_pagamentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_pagamento" do
    assert_difference('TipoPagamento.count') do
      post :create, :tipo_pagamento => { }
    end

    assert_redirected_to tipo_pagamento_path(assigns(:tipo_pagamento))
  end

  test "should show tipo_pagamento" do
    get :show, :id => tipo_pagamentos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tipo_pagamentos(:one).to_param
    assert_response :success
  end

  test "should update tipo_pagamento" do
    put :update, :id => tipo_pagamentos(:one).to_param, :tipo_pagamento => { }
    assert_redirected_to tipo_pagamento_path(assigns(:tipo_pagamento))
  end

  test "should destroy tipo_pagamento" do
    assert_difference('TipoPagamento.count', -1) do
      delete :destroy, :id => tipo_pagamentos(:one).to_param
    end

    assert_redirected_to tipo_pagamentos_path
  end
end
