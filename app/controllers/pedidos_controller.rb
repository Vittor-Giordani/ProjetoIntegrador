class PedidosController < ApplicationController
  before_action :set_mesa, only: [:index, :create]
  before_action :carregar_dados, only: [:index]
  
  def index
  end
  
  def create
    @pedido = @mesa.pedidos.new(pedido_params)
    @pedido.data_hora ||= Time.current
    @pedido.status ||= 'aberto'  # ← ADICIONE ESTA LINHA!
    
    puts "=== CRIANDO PEDIDO ==="
    puts "Status do pedido: #{@pedido.status}"
    puts "Mesa status: #{@mesa.status}"
    
    if @pedido.save
      puts "Pedido salvo! ID: #{@pedido.id}, Status: #{@pedido.status}"
      
      if @mesa.status == 'livre'
        @mesa.update!(status: 'ocupada')
        puts "Mesa atualizada para: ocupada"
      end
      
      flash[:success] = 'Pedido criado com sucesso!'
      redirect_to mesa_path(@mesa)
    else
      puts "ERRO: #{@pedido.errors.full_messages}"
      flash[:error] = 'Erro ao criar pedido.'
      redirect_to mesa_path(@mesa)
    end
  end
  
  private
  
  def set_mesa
    @mesa = Mesa.find(params[:mesa_id])
  end
  
  def carregar_dados
    # DEBUG ADICIONAL
    puts "=== CARREGANDO DADOS MESA #{@mesa.id} ==="
    puts "Usuário atual ID: #{current_user.id}"
    puts "Mesa status: #{@mesa.status}"
    
    # 1. Mostrar TODOS os pedidos primeiro (para debug)
    todos_pedidos = @mesa.pedidos.order(data_hora: :desc)
    puts "Todos os pedidos: #{todos_pedidos.count}"
    todos_pedidos.each do |p|
      puts "  Pedido #{p.id}: status=#{p.status}, data=#{p.data_hora}"
    end
    
    # 2. Agora filtrar por 'aberto'
    @pedidos = @mesa.pedidos.where(status: 'aberto').order(data_hora: :desc)
    puts "Pedidos ABERTOS: #{@pedidos.count}"
    
    # 3. Carregar itens
    @itens_pedidos = ItemPedido.where(codigo_pedido: @pedidos.pluck(:codigo_pedido))
    puts "Itens carregados: #{@itens_pedidos.count}"
    
    # 4. Carregar garçons
    @garcons = Garcon.do_usuario(current_user.id).order(:nome)
    puts "Garçons do usuário: #{@garcons.count}"
    
    # 5. Carregar produtos - ADICIONE MAIS DEBUG AQUI
    @produtos = Produto.do_usuario(current_user.id).where(status: 'ativo').order(:nome)
    puts "Produtos ativos do usuário: #{@produtos.count}"
    
    # DEBUG DETALHADO DOS PRODUTOS
    if @produtos.any?
      @produtos.each do |produto|
        puts "  Produto: #{produto.nome} (ID: #{produto.codigo_produto}, Valor: #{produto.valor}, Status: #{produto.status}, User: #{produto.user_id})"
      end
    else
      puts "  NENHUM PRODUTO ENCONTRADO!"
      puts "  Verificando todos os produtos..."
      todos_produtos = Produto.all
      puts "  Total de produtos no banco: #{todos_produtos.count}"
      todos_produtos.each do |p|
        puts "    Produto: #{p.nome}, User ID: #{p.user_id}, Status: #{p.status}"
      end
    end
    
    # 6. Instanciar novos objetos
    @novo_pedido = Pedido.new
    @novo_item_pedido = ItemPedido.new
  end
  
  def pedido_params
    params.require(:pedido).permit(:codigo_garcom, :observacoes)
  end
end