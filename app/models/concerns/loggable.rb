module Loggable
  extend ActiveSupport::Concern

  def registrar_log(acao, detalhes = nil)
    email = obter_email_usuario
    Log.registrar(email, acao, detalhes)
  end

  def log_criacao(objeto)
    registrar_log("Cadastrou #{nome_do_model(objeto)}", detalhes_do_objeto(objeto))
  end

  def log_edicao(objeto)
    registrar_log("Editou #{nome_do_model(objeto)}", detalhes_do_objeto(objeto))
  end

  def log_exclusao(objeto)
    registrar_log("Excluiu #{nome_do_model(objeto)}", detalhes_do_objeto(objeto))
  end

  def log_fechamento_conta(mesa, total)
    registrar_log("Fechou conta", "Mesa: #{mesa.numero}, Total: R$ #{sprintf('%.2f', total)}")
  end

  def log_adicao_produto(mesa, produto, quantidade)
    registrar_log("Adicionou produto ao pedido", "Mesa: #{mesa.numero}, Produto: #{produto.nome}, Quantidade: #{quantidade}")
  end

  def log_remocao_produto(mesa, produto)
    registrar_log("Removeu produto do pedido", "Mesa: #{mesa.numero}, Produto: #{produto.nome}")
  end

  def log_reativacao(objeto)
    registrar_log("Reativou #{nome_do_model(objeto)}", detalhes_do_objeto(objeto))
  end

  private

  def obter_email_usuario
    # Tenta obter o email do usuário logado de diferentes formas
    if respond_to?(:current_user) && current_user
      current_user.email
    elsif @usuario_logado
      @usuario_logado.email
    elsif session[:user_email]
      session[:user_email]
    else
      'Sistema'
    end
  end

  def nome_do_model(objeto)
    objeto.class.model_name.human
  end

  def detalhes_do_objeto(objeto)
    if objeto.respond_to?(:numero)
      "Número: #{objeto.numero}"
    elsif objeto.respond_to?(:nome)
      "Nome: #{objeto.nome}"
    elsif objeto.respond_to?(:codigo)
      "Código: #{objeto.codigo}"
    else
      "ID: #{objeto.id}"
    end
  end
end