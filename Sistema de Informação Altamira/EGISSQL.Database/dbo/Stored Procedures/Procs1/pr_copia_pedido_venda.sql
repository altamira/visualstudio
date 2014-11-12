
CREATE PROCEDURE pr_copia_pedido_venda
@cd_pedido_origem      int = 0,
@cd_usuario            int = 0,
@cd_cliente            int = 0
as

-- Retornará ZERO se não encontrar o pedido Origem
declare @cd_pedido_venda int

declare @sg_estado_cliente            varchar(2),  
        @cd_destinacao_produto        integer,
        @cd_estado                    int,
        @cd_pais                      int,
        @ic_zera_preco_venda_especial char(1)
  

select
  @ic_zera_preco_venda_especial = isnull(ic_zera_preco_venda_especial,'N')
from
  parametro_copia_pedido with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


declare @cd_cliente_antigo int

set @cd_pedido_venda = 0

--Verifica se a Consulta de origem Existe

if exists( select cd_pedido_venda from Pedido_Venda where cd_pedido_venda = @cd_pedido_origem )
begin

declare @Tabela	     varchar(50)

set @Tabela      = cast(DB_NAME()+'.dbo.Pedido_Venda' as varchar(50))

while @cd_pedido_venda = 0
begin

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_pedido_venda output


  --Verifica se Existe o Pedido na Tabela

  if not exists(select cd_pedido_venda from pedido_venda where @cd_pedido_venda=cd_pedido_venda )
  begin

   --Cria uma Tabela Temporária - Pedido
   set @cd_cliente_antigo =  (select cd_cliente  from Pedido_Venda      
          where  cd_pedido_venda = @cd_pedido_origem)  


   --Verifica se foi passado o cliente
   if @cd_cliente = 0 
   begin
     set @cd_cliente = @cd_cliente_antigo
   end

   declare @dt_pedido_venda datetime

   --set @dt_pedido_venda = dbo.fn_data( getdate() )
   set @dt_pedido_venda = cast(convert(int,getdate(),103) as datetime)

   --select @dt_pedido_venda

   select
     *
   into #Pedido
   from
     Pedido_Venda
   where
     cd_pedido_venda = @cd_pedido_origem

   --select * from #Pedido

    --Geração um Novo Pedido
    --select * from pedido_venda where cd_pedido_venda = 6762
    update
      #Pedido
    set
		--Márcio 02/03/05
      cd_cliente                = @cd_cliente,  
      --Operação Triagular-----------------------------Manter o Mesmo
      --cd_cliente_faturar        = @cd_cliente,  
      cd_cliente_entrega        = @cd_cliente,  
      cd_pedido_venda           = @cd_pedido_venda,
      dt_pedido_venda           = @dt_pedido_venda, --cast( cast( getdate() as int ) as datetime ),
      cd_usuario                = @cd_usuario,
      dt_usuario                = getdate(),
      dt_fechamento_pedido      = Null,
      dt_alteracao_pedido_venda = Null,
      nm_referencia_consulta    =  (case @cd_cliente   
              							when cd_cliente then  
                   						nm_referencia_consulta  
              							else  
             								''    
              							end),
      dt_credito_pedido_venda   = Null,
      cd_usuario_credito_pedido = Null,
      cd_status_pedido          = 1, --Pedido em Aberto  ,
      ic_emitido_pedido_venda   = 'N',
      dt_cancelamento_pedido    = null,
      ds_cancelamento_pedido    = cast(null as varchar),
      ic_fechado_pedido         = 'N',
      ic_fechamento_total       = 'N'
    where
      cd_pedido_venda = @cd_pedido_origem

    --select * from #Pedido

    insert into
      Pedido_Venda
    select
      *
    from
      #Pedido

   --Itens do Pedido de Venda
    Select top 1 @sg_estado_cliente = e.sg_estado,  
                 @cd_destinacao_produto = c.cd_destinacao_produto,
                 @cd_estado = cli.cd_estado,
                 @cd_pais   = cli.cd_pais 
    from   
 		Pedido_Venda c           with (nolock) 
                inner join   Cliente cli with (nolock) on c.cd_cliente  = cli.cd_cliente
                inner join   Estado e    with (nolock) on cli.cd_estado = e.cd_estado  
    where  
 		--cd_pedido_venda = @cd_pedido_origem 
      cli.cd_cliente = @cd_cliente 
       

   --Cria uma Tabela Temporária - Itens do Pedido de Venda

   select
     *
   into #Pedido_Itens
   from
     Pedido_Venda_Item
   where
     cd_pedido_venda = @cd_pedido_origem

    --Geração da Nova Tabela de Itens do Pedido
    --select * from pedido_venda_item

    update
      #Pedido_Itens
    set
      cd_pedido_venda           = @cd_pedido_venda,
      qt_saldo_pedido_venda     = qt_item_pedido_venda, --saldo do Pedido de venda para ficar em aberto
      cd_usuario                = @cd_usuario,
      dt_usuario                = getdate(),
      dt_fechamento_pedido      = Null,
      ic_sel_fechamento         = 'N',
      cd_usuario_lib_desconto   = 0, 
      dt_desconto_item_pedido   = Null,
      ic_desconto_item_pedido   = 'N',
      cd_posicao_item_pedido    = Null,
--      dt_entrega_vendas_pedido  = getdate() + qt_dia_entrega_pedido,  
      dt_entrega_vendas_pedido = (convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)) 
                                 + qt_dia_entrega_pedido,

      nm_kardex_item_ped_venda  =  (case @cd_cliente   
              								when @cd_cliente_antigo then  
                   							  nm_kardex_item_ped_venda  
              								else  
            									 ''    
              								end),  
      --Atualiza o Preço de Venda 
      --Carlos 11.07.2005   
      vl_unitario_item_pedido     = case when isnull(cd_produto,0) = 0 and isnull(i.cd_servico,0)=0 and @ic_zera_preco_venda_especial = 'S' 
                                    then
                                      0.00 
                                    else 
                                      vl_unitario_item_pedido 
                                    end,
 
      --Atualiza o valor de lista do produto  / preço orçado
 
     vl_lista_item_pedido    = case when IsNull(cd_produto,0)=0 and isnull(i.cd_servico,0)=0 and @ic_zera_preco_venda_especial='S'
                               then
                                 0.00
                               else 
                                 case when isnull(i.cd_servico,0) > 0
                                 then
                                   isnull(s.vl_servico,vl_lista_item_pedido)
                                 else	
                                   Case when dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente)>0 
                                   then
                                     dbo.fn_vl_produto_cliente(isnull(cd_produto,0), @cd_cliente)
                                   else
                                     case when dbo.fn_vl_venda_produto(@sg_estado_cliente, @cd_destinacao_produto, cd_produto)>0 
                                     then
                                        dbo.fn_vl_venda_produto(@sg_estado_cliente, @cd_destinacao_produto, cd_produto)  
                                     else       
                                        vl_lista_item_pedido
                                     end
                                   end
                                 end
                               end,

      pc_ipi  =  case when isnull(cd_produto,0)>0 
                 then
                  isNull(dbo.fn_get_ipi_produto(isnull(cd_produto,0)),0)
                 else
                  i.pc_ipi end,

      pc_icms =  case when isnull(cd_produto,0)>0 
                 then
                   dbo.fn_vl_icms_produto_estado(isnull(@cd_estado,0),isnull(@cd_pais,0),isnull(cd_produto,0))
                 else
                   i.pc_icms
                 end

      from
        #Pedido_itens i
        left join Servico s on s.cd_servico = i.cd_servico
    where
      cd_pedido_venda = @cd_pedido_origem

      --Verificar se o Item é Serviço busca o preço de lista do Serviço

    insert into
      Pedido_Venda_Item
    select
      *
    from
      #Pedido_Itens


    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'

    --Realiza a cópia das tabelas complementares do Pedido
    exec dbo.pr_copia_pedido_complementar @cd_pedido_origem, @cd_pedido_venda, @cd_usuario  


  end
  else
    begin

      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_venda, 'D'
      set @cd_pedido_venda=0
    end

end

end

select @cd_pedido_venda as cd_pedido_venda


--select * from status_proposta

