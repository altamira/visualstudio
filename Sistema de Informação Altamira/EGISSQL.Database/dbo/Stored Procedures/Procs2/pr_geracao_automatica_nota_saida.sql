
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_automatica_nota_saida
-------------------------------------------------------------------------------
--pr_geracao_automatica_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Geração Automática de Nota Fiscal 
--                   Atualização automática do Estoque à partir dos pedidos
--                   de venda
--
--Data             : 30.03.2009
--Alteração        : 01.04.2009 - Ajuste na Consulta - Carlos Fernandes
--
-- 02.04.2009 - Complemento dos Campos - Carlos Fernandes
-- 07.04.2009 - Data de Saída - Carlos Fernandes
-- 11.04.2009 - Operação Fiscal de Bonificação - Carlos Fernandes
-- 29.04.2009 - Ajuste da Movimentação de Estoque - Carlos Fernandes
-- 02.05.2009 - Flag de Fechamento de Pedido - Carlos Fernandes
-- 04.05.2009 - Caso não tenha estoque não faturar o Produto - Carlos Fernandes
-- 05.05.2009 - Não Trava Estoque - Carlos Fernandes
-------------------------------------------------------------------------------
create procedure pr_geracao_automatica_nota_saida
@ic_parametro        int      = 0,  
@dt_inicial          datetime = '',  
@dt_final            datetime = '',  
@cd_vendedor         int      = 0,  
@cd_usuario          int      = 0,
@dt_nota_saida       datetime = '',
@dt_saida_nota_saida datetime = '',
@cd_pedido_venda     int      = 0
  
  
--select * from nota_saida

as  

if @dt_nota_saida is null
begin
   --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)
   set @dt_nota_saida = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

if @dt_saida_nota_saida is null
begin
   --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)
   set @dt_saida_nota_saida = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end


declare @cd_fase_produto             int  

  --Busca a Fase do Produto------------------------------------------------------  
  
  select  
    @cd_fase_produto = isnull(cd_fase_produto,0)  
  from  
    Parametro_Comercial with (nolock)   
  where  
    cd_empresa = dbo.fn_empresa()  

------------------------------------------------------------------------------------

  
--select * from pedido_venda  
  
-- declare @dt_pedido_venda datetime  
--   
-- set @dt_pedido_venda = '03/30/2009'  

--select * from pedido_venda
  
select  
  pv.cd_pedido_venda,  
  max(pv.dt_pedido_venda)                         as dt_pedido_venda,  
  max(pv.cd_cliente)                              as cd_cliente,  
  max(pv.cd_vendedor)                             as cd_vendedor,  
  max(c.nm_fantasia_cliente)                      as nm_fantasia_cliente,  
  max(v.nm_fantasia_vendedor)                     as nm_fantasia_vendedor,  
  max(pv.vl_total_pedido_venda)                   as vl_total_pedido_venda,  
  max(tp.nm_tipo_pessoa)                          as nm_tipo_pessoa,  
  max(sc.nm_status_cliente)                       as nm_status_cliente,  
  max(c.cd_cnpj_cliente)                          as cd_cnpj_cliente,  
  max(c.cd_inscestadual)                          as cd_inscestadual,
  max(cp.nm_condicao_pagamento)                   as nm_condicao_pagamento,
  max(fp.nm_forma_pagamento)                      as nm_forma_pagamento,  
  max(fp.ic_nota_forma_pagamento)                 as ic_nota_forma_pagamento,    
  max(isnull(pv.ic_bonificacao_pedido_venda,'N')) as ic_bonificacao_pedido_venda

into  
  #Pedido  
  
from  
  Pedido_Venda pv                       with (nolock)   
  inner join pedido_venda_item pvi      with (nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda  
  left outer join Produto p             with (nolock) on p.cd_produto             = pvi.cd_produto 
  left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida     = pvi.cd_unidade_medida
  left outer join Cliente c             with (nolock) on c.cd_cliente             = pv.cd_cliente  
  left outer join Vendedor v            with (nolock) on v.cd_vendedor            = pv.cd_vendedor  
  left outer join Status_Cliente sc     with (nolock) on sc.cd_status_cliente     = c.cd_status_cliente
  left outer join Tipo_Pessoa    tp     with (nolock) on tp.cd_tipo_pessoa        = c.cd_tipo_pessoa  
  left outer join Condicao_Pagamento cp with (nolock) on cp.cd_condicao_pagamento = pv.cd_condicao_pagamento
  left outer join 
       Cliente_Informacao_Credito ci    with (nolock) on ci.cd_cliente            = c.cd_cliente
  left outer join Forma_Pagamento fp    with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento


  --Comentado - 05.05.2009

--   left outer join Produto_Saldo pso     with (nolock) on pso.cd_produto              = p.cd_produto and
--                                                          pso.cd_fase_produto         = 
--                                                          case when isnull(p.cd_fase_produto_baixa,0)>0 
--                                                          then 
--                                                            p.cd_fase_produto_baixa 
--                                                          else
--                                                            @cd_fase_produto
--                                                          end
-- 
--   left outer join Produto_Saldo ps      with (nolock) on ps.cd_produto              = p.cd_produto and
--                                                          ps.cd_fase_produto         = 
--                                                          case when isnull(um.cd_fase_produto,0)>0 then
--                                                                um.cd_fase_produto
--                                                              else
--                                                                case when isnull(p.cd_fase_produto_baixa,0)>0 then 
--                                                                  p.cd_fase_produto_baixa 
--                                                                else
--                                                                  @cd_fase_produto
--                                                                end
--                                                              end


--select * from forma_pagamento
       
where  
  pv.dt_pedido_venda between @dt_inicial and @dt_final and  
  isnull(pv.ic_fechado_pedido,'N') = 'S'               and --Pedido de Venda Fechado
  isnull(pvi.qt_saldo_pedido_venda,0)>0                and  
  pvi.dt_cancelamento_item is null                     and  
  --Verifica se o Crédito foi Liberado  
  pv.dt_credito_pedido_venda is not null               and  
  pv.cd_pedido_venda not in ( select nsi.cd_pedido_venda 
                              from Nota_Saida_Item nsi with (nolock)
                              where nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                    nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda )   

--  and
--  (isnull(pso.qt_saldo_atual_produto,0)>0 or isnull(ps.qt_saldo_atual_produto,0)>0)

--select * from produto_saldo
  
group by
  pv.cd_pedido_venda

--select * from pedido_venda_item  
  
--select * from #Pedido  
  
--Mostra os Pedidos que vão ser faturado  
  
if @ic_parametro = 1  
begin  
  
  select * from #Pedido  
  order by  
    dt_pedido_venda,  
    cd_vendedor  
      
  
end  
  
-------------------------------------------------------------------------------  
  
--Geração das Notas Fiscais  
  
-------------------------------------------------------------------------------  
  
if @ic_parametro = 2  
begin  
  
  --DELETE os pedidos de venda que não permitem faturamento

--   delete from #Pedido  
--   where
--     ic_nota_forma_pagamento = 'N'
  

  
-------------------------------------------------------------------------------  
--Atualização do Estoque  
-------------------------------------------------------------------------------  
--produto_saldo  
  
  declare @cd_nota_saida               int  
  declare @cd_item_nota_saida          int  
  declare @cd_item_pedido_venda        int  
  declare @cme                         int  
  declare @cd_produto                  int  
  declare @qt_produto_atualizacao      float  
  declare @vl_unitario_movimento       float  
  declare @vl_total_movimento          float  
  declare @nm_historico_movimento      varchar(40)  
  declare @qt_saldo_reserva_produto    float  
  declare @cd_tabela_preco             int  
  declare @cd_tabela_preco_produto     int  
  declare @cd_mascara_produto          varchar(20)  
  declare @vl_tabela_produto           float  
  declare @nm_fantasia_cliente         varchar(15)  
  declare @dt_geracao                  datetime  
  declare @cd_cliente                  int  

  --declare @dt_nota_saida           datetime  
    
--  declare @cd_item_pedido_venda     int  
  
  if @dt_geracao is null  
  begin  
     --set @dt_geracao = cast(convert(int,getdate(),103) as datetime)  
     set @dt_geracao = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)  
  end  
  
  --select * from operacao_fiscal  
  
  --declare @cd_pedido_venda      int  
  declare @cd_operacao_fiscal   int  
  declare @ic_estoque_op_fiscal char(1)  
  declare @cd_unidade_medida    int

  set @cd_pedido_venda = 0
    
  while exists( select top 1 cd_pedido_venda from #Pedido)  
  begin  

    select top 1  
      @cd_cliente          = cd_cliente,  
      @cd_pedido_venda     = cd_pedido_venda,  
      @nm_fantasia_cliente = nm_fantasia_cliente  
    from  
      #Pedido  
    order by  
      dt_pedido_venda,  
      cd_vendedor  
  
  
    --gera nota de Saída  
  
    exec pr_gera_nota_saida   
         @cd_pedido_venda,  
         @cd_usuario,
         @dt_nota_saida,     
         null,
         @dt_saida_nota_saida  
  
    --Movimentação de Estoque  
     
    --select * from nota_saida_item  
  
    select  
      ns.cd_nota_saida,  
      ns.dt_nota_saida,  
      nsi.cd_item_nota_saida,  
      nsi.cd_produto,  
      nsi.qt_item_nota_saida,  
      nsi.cd_unidade_medida,  
      nsi.cd_pedido_venda,  
      nsi.cd_item_pedido_venda,  
      nsi.cd_operacao_fiscal,  
      --isnull(nsi.cd_fase_produto, p.cd_fase_produto_baixa ) as cd_fase_produto,  
      --nsi.cd_item_pedido_venda,  
      nsi.vl_unitario_item_nota,  
      nsi.vl_total_item,
      --nsi.cd_unidade_medida,  
      isnull(p.qt_multiplo_embalagem,0) as  qt_multiplo_embalagem,
      --Fase do Produto------------------------------------------------------------
      cd_fase_produto          = case when isnull(um.cd_fase_produto,0)>0 
                                then
                                  um.cd_fase_produto
                                else
                                  case when isnull(p.cd_fase_produto_baixa,0)>0 then
                                     isnull(p.cd_fase_produto_baixa,@cd_fase_produto)
                                  else
                                    @cd_fase_produto
                                  end
                                end

    into  
      #ItemNota  
    from  
      Nota_Saida ns                     with (nolock)    
      inner join Nota_Saida_Item nsi    with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida  
      left outer join produto p         with (nolock) on nsi.cd_produto    = p.cd_produto  
      left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = nsi.cd_unidade_medida
    where  
      nsi.cd_pedido_venda = @cd_pedido_venda  
  
    --Gerando Movimento de Estoque dos Itens  
  
    while exists( select top 1 cd_item_nota_saida from #ItemNota )  
    begin  
  
      select top 1  
        @cd_nota_saida          = cd_nota_saida,  
        @dt_nota_saida          = dt_nota_saida,  
        @cd_item_nota_saida     = cd_item_nota_saida,  
        @cd_fase_produto        = isnull(cd_fase_produto,@cd_fase_produto),  
        --Ajuste da Quantidade que terá que ser atualizada/baixada no Estoque
        @qt_produto_atualizacao = isnull(qt_item_nota_saida,0),  
        @cd_operacao_fiscal     = isnull(cd_operacao_fiscal,0),  
        @cd_item_pedido_venda   = isnull(cd_item_pedido_venda,0),  
        @vl_unitario_movimento  = isnull(vl_unitario_item_nota,0),  
        @vl_total_movimento     = isnull(vl_total_item,0),  
        @cd_produto             = isnull(cd_produto,0)  
      from  
        #ItemNota               
     
  
      select  
        @ic_estoque_op_fiscal = isnull(ic_estoque_op_fiscal,'N')  
      from  
        Operacao_Fiscal opf   
      where  
        cd_operacao_fiscal = @cd_operacao_fiscal  
  
      if @ic_estoque_op_fiscal = 'S'   
      begin  
        --print 'Estoque'  
  
        --select * from movimento_estoque  
  
        set   
           @nm_historico_movimento = 'Nota Fiscal No '+rtrim(ltrim(cast(@cd_nota_saida as varchar)))+' - '+' PV '+rtrim(ltrim(cast(@cd_pedido_venda      as varchar)))+'/'+  
               rtrim(ltrim(cast(@cd_item_pedido_venda as varchar)))+' '+@nm_fantasia_cliente  
  
        --print @dt_nota_saida  
        --print @cd_produto  
        --print @cd_fase_produto  
        --print @qt_produto_atualizacao  
        --print @cd_nota_saida  
        --print @cd_item_nota_saida  
  
        --Atualização do Estoque  
  
        exec pr_Movimenta_estoque    
          1,                       --Inclusão  
          11,                      --Tipo de Movimentação de Estoque  
          NULL,                    --Tipo de Movimentação de Estoque (OLD)  
          @cd_produto,             --Produto  
          @cd_fase_produto,        --Fase de Produto  
          @qt_produto_atualizacao, --Quantidade  
          NULL, --Quantidade Antiga  
          @dt_nota_saida,          --Data do Movimento de Estoque  
          @cd_nota_saida,          --Nota de Saida  
          @cd_item_nota_saida,     --Item da Nota  
          4,                       --Tipo de Documento  
          @dt_geracao,             --Data do Pedido  
          NULL,                    --Centro de Custo  
          @vl_unitario_movimento,  --Valor Unitário  
          @vl_total_movimento,     --Valor Total  
          'N',                     --Peps Não  
          'N',                     --Mov. Terceiro  
          @nm_historico_movimento, --Histórico  
          'S',                     --Mov. Saída  
          @cd_cliente,             --Cliente  
          NULL,                    --Fase de Entrada ?  
          '0',                     --Fase de Entrada  
          @cd_usuario,  
          @dt_geracao,             --Data do Usuário  
          1,                       --Tipo de Destinatário = Cliente  
          @nm_fantasia_cliente,   
          0.00,                    --Valor Fob  
          0.00,                    --Custo Contábil,  
          0.00,                    --Valor Fob Convertido,  
          0,                       --Produto Anterior  
          0,                       --Fase Anterior  
          'N',                     --Consignação,   
          'N',                     --Amostra           
          'A',                     --Tipo de Lançamento = 'A'=Automático   
          0,                       --Item da Composição  
          0,                       --Histórico  
          @cd_operacao_fiscal,     --Operação Fiscal,  
          NULL,                    --Série da Nota  
          @cme,                    --Código do Movimento de Estoque     
          NULL,                    --Lote   
          NULL,                    --Tipo de Movimento Transferência  
          NULL,                    --Unidade  
          NULL,                    --Unidade Origem  
          NULL,                    --Fator  
          NULL,                    --Qtd. Original  
          'N',                     --Atualiza Saldo Lote  
          NULL,                    --Lote Anterior  
          NULL                     --Custo da Comissão  
  
       end  
      
       delete from #ItemNota  
       where  
         cd_nota_saida      = @cd_nota_saida and  
         cd_item_nota_saida = @cd_item_nota_saida  
  
    end  
  
    drop table #ItemNota  
  
    --Atualiza o Flag de Nota Impressa  
    --select * from nota_saida  
  
    --Temporário porque será feito na emissão da DANFE.  
  
    update  
      nota_saida  
    set  
      ic_emitida_nota_saida = 'S',   
      cd_status_nota        = 5  
  
    where  
      cd_nota_saida = @cd_nota_saida  
  
    delete from #Pedido  
    where  
      cd_pedido_venda = @cd_pedido_venda  
  
  
  end  
  
end  

-------------------------------------------------------------------------------  
  
--Mostra os itens do Pedido de Venda
  
-------------------------------------------------------------------------------  
  

if @ic_parametro = 3
begin  

  select
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.nm_fantasia_produto,
    pvi.qt_saldo_pedido_venda,
    pvi.nm_produto_pedido
  from
    pedido_venda_item   pvi with (nolock)
    inner join #Pedido  p   with (nolock) on p.cd_pedido_venda = pvi.cd_pedido_venda
  where
    p.cd_pedido_venda = @cd_pedido_venda

end
  
-------------------------------------------------------------------------------  
  
drop table #Pedido  
  
-------------------------------------------------------------------------------  
  

