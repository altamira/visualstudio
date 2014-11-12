
create procedure pr_analise_disponibilidade_produto
@ic_parametro int = 0,
@cd_produto   int = 0,
@cd_usuario   int = 0,
@cd_vendedor  int = 0

as

  declare @cd_fase_produto    int
  declare @cd_controle        int
  declare @qt_saldo           float
  declare @qt_movimento       float 
  declare @qt_total_movimento float
  declare @ic_utilizar        char(1)
  declare @dt_hoje            datetime
  declare @nm_usuario_logado  varchar(100)
  declare @cSQL               varchar(8000)


  set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121) 

  --Define o usuário logado
  Select @nm_usuario_logado = RTrim(LTrim(USER_NAME()))


  --------------------------------------------------
  -- Apagar a tabela de Alocação

  ---------------------------------------------------
  if exists(Select * from sysobjects
            where name = 'ANALISE_ALOCACAO' and
                  xtype = 'U' AND
                  uid = USER_ID(@nm_usuario_logado))
  begin
    set @cSQL = ' DROP TABLE ' + @nm_usuario_logado + '.' + 'ANALISE_ALOCACAO'
    exec(@cSQL)
  end

--Montagem da Tabela Temporária

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

--select * from produto
--select * from produto_saldo
--select * from vw_reserva_produto_estoque


---------------------------------------------------------------------------------------
--Somente a Consulta - Reservas Alocadas
---------------------------------------------------------------------------------------

if @ic_parametro = 1
begin

select
  identity(int,1,1)                               as cd_controle,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  p.qt_minimo_venda_produto,
  um.sg_unidade_medida,
  pimp.cd_part_number_produto,
  fp.nm_fase_produto,
  isnull(ps.qt_saldo_reserva_produto,0)           as Disponivel,
  isnull(ps.qt_saldo_atual_produto,0)             as Atual,
  isnull(ps.qt_minimo_produto,0)                  as Minimo,
  c.nm_fantasia_cliente                           as Cliente, 
  pvi.dt_entrega_vendas_pedido                    as Entrega,
  pvi.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  cast(pv.cd_pedido_venda as varchar)             as Pedido,
  pv.dt_pedido_venda,
  pvi.cd_item_pedido_venda                        as Item,
  pvi.qt_saldo_pedido_venda,

  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
     pvi.qt_saldo_pedido_venda                   
  else
     pvi.qt_item_pedido_venda
  end                                             as Quantidade,

  pvi.dt_entrega_vendas_pedido,

  --select * from pedido_venda_item
  --select * from atendimento_pedido_venda where cd_produto = 81

--   case when isnull(apv.cd_documento,0)=0 and isnull(ps.qt_saldo_atual_produto,0)>0 
--   then
--     'S'
--   else
--     'N'
--   end                                             as Estoque,

  --select * from estoque_pedido_venda

  case when isnull(epv.qt_estoque,0)>0
  then
    'S'
  else
    'N'
  end                                                as Estoque,

  case when isnull(epv.qt_estoque,0)>0 then
    epv.qt_estoque
  else
    0.00
  end                                                as QtdEstoque,  

  case when isnull(epv.qt_estoque,0)>0 and isnull(pvi.qt_saldo_pedido_venda,0)>0 then
    isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )
  else
    case when isnull(pvi.qt_estoque,0)>0 and pvi.qt_item_pedido_venda>0 then
       isnull(pvi.qt_item_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )
    else
      0.00
    end
  end                                                as Saldo, 

--   case when isnull(apv.cd_documento,0)=0 and isnull(ps.qt_saldo_atual_produto,0)>0 
-- 
--   then 
--     case when pvi.qt_saldo_pedido_venda<=isnull(ps.qt_saldo_atual_produto,0)  then
--          pvi.qt_saldo_pedido_venda
--     else
--       case when pvi.qt_saldo_pedido_venda>isnull(ps.qt_saldo_atual_produto,0) then
--         isnull(ps.qt_saldo_atual_produto,0)
--       else
--         0.00
--       end
--     end
--   else
--    0.00
--   end                                             as QtdEstoque,

--   case when isnull(apv.cd_documento,0)=0 and isnull(ps.qt_saldo_atual_produto,0)>0 
--   then
--     case when pvi.qt_saldo_pedido_venda<=isnull(ps.qt_saldo_atual_produto,0)  then
--          0
--     else
--       case when pvi.qt_saldo_pedido_venda>isnull(ps.qt_saldo_atual_produto,0) then
--         pvi.qt_saldo_pedido_venda-isnull(ps.qt_saldo_atual_produto,0)
--       else
--         0.00
--       end
--     end
--   else
--     case when isnull(apv.cd_documento,0)>0 then
--       cast(pvi.qt_saldo_pedido_venda as float)        
--     else
--       0
--     end
--   end                                             as Saldo,

  pvi.vl_unitario_item_pedido,
 
  --Dados do Atendimento

    cast('' as varchar(20))                       as Destino,
    apv.nm_forma                                  as Forma,
    apv.cd_documento                              as Documento,
    apv.cd_item_documento                         as ItemDocumento,
    apv.dt_atendimento                            as DataPrevisao,
    apv.qt_atendimento,

    --Atendimento

    case when isnull(apv.cd_documento,0)=0 and isnull(ps.qt_saldo_atual_produto,0)>0 then
      'Estoque'
    else
      case when isnull(apv.cd_documento,0)>0 then
        'Previsto'
      else
        'Não Atendido'
      end
    end                                   as nm_atendimento,

  cast(pvi.dt_entrega_vendas_pedido-isnull(apv.dt_atendimento,@dt_hoje) as int ) as Dias,

--  Entrada = cast('' as char(1)),

  Entrada = ( select top 1 'S' 
              from 
                vw_previsao_entrada_atendimento vwe with (nolock) 
              where
                vwe.CodigoProduto = p.cd_produto
              order by
                DataPrevisao),

  --Verifica se o Pedido está Alocado

  case when apv.qt_atendimento>0 
  then 'S'
  else 'N'
  end                                       as Atendimento,

  cast(apv.qt_atendimento as float)         as QtdAtendimento,

  case when isnull(apv.qt_atendimento,0)=0 and isnull(epv.qt_estoque,0)=0 then
    pvi.qt_saldo_pedido_venda
  else
    0.00
  end                                       as QtdNaoAtendida,


  --Endereço do Produto
  --dbo.fn_produto_localizacao(p.cd_produto, fp.cd_fase_produto) as 'localizacao'

  cast('' as varchar(30))                   as Localizacao,

  cf.cd_mascara_classificacao,
  cf.pc_ipi_classificacao,
  cf.ic_subst_tributaria,
  cf.ic_base_reduzida,
  ve.nm_fantasia_vendedor                   as nm_vendedor_externo,
  vi.nm_fantasia_vendedor                   as nm_vendedor_interno,
  pvi.dt_cancelamento_item,
  cast('' as varchar(80))                   as nm_obs_item_pedido,
  isnull(pvi.dt_reprog_item_pedido,pvi.dt_entrega_vendas_pedido) 
                                            as dt_reprog_item_pedido,

  --pvi.vl_unitario_item_pedido,

  pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido         as vl_total_item_pedido,
  pvi.cd_moeda_cotacao,
  m.sg_moeda,                
  pvi.dt_moeda_cotacao,
  pvi.vl_moeda_cotacao,

  --isnull(pvi.dt_reprog_item_pedido,dt_entrega_vendas_pedido) as dt_reprog_item_pedido,
  '('+ltrim(rtrim(c.cd_ddd))+')-'+ltrim(rtrim(c.cd_telefone))     as cd_telefone_cliente,
  cc.nm_contato_cliente,
  tp.nm_tipo_pedido,
  pvi.cd_consulta,
  pvi.cd_item_consulta,

  --Nota Fiscal

  nsi.cd_nota_saida,
  nsi.dt_nota_saida,
  nsi.dt_saida_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  nsi.qt_devolucao_item_nota,
  nsi.qt_item_nota_saida as qt_faturada,
  nsi.cd_status_nota    


  --vw.dt_cancelamento_item

into
  #ConsultaReserva
  --ANALISE_ALOCACAO

from
  Produto p                                       with (nolock) 
  left outer join unidade_medida um               with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  inner join fase_produto fp                      with (nolock) on fp.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                                          then
                                                                                            p.cd_fase_produto_baixa 
                                                                                          else 
                                                                                             @cd_fase_produto
                                                                                          end
  left outer join produto_saldo ps                with (nolock) on ps.cd_produto          = p.cd_produto and
                                                                   ps.cd_fase_produto     = fp.cd_fase_produto

  inner join pedido_venda_item pvi                with (nolock) on pvi.cd_produto         = p.cd_produto
 
  inner join pedido_venda      pv                 with (nolock) on pv.cd_pedido_venda     = pvi.cd_pedido_venda  

  left outer join tipo_pedido tp                  with (nolock) on tp.cd_tipo_pedido      = pv.cd_tipo_pedido

  --Reserva
  --inner join vw_reserva_geral_produto_estoque vw  with (nolock) on vw.cd_produto         = p.cd_produto 
                                                                   
  
  left outer join Cliente c                       with (nolock) on c.cd_cliente           = pv.cd_cliente
  left outer join Cliente_Contato cc              with (nolock) on cc.cd_cliente          = pv.cd_cliente and
                                                                   cc.cd_contato          = pv.cd_contato

  left outer join vendedor ve                     with (nolock) on ve.cd_vendedor         = pv.cd_vendedor
  left outer join vendedor vi                     with (nolock) on vi.cd_vendedor         = pv.cd_vendedor_interno

  left outer join Moeda m                         with (nolock) on m.cd_moeda             = pvi.cd_moeda_cotacao

  --Atendimento

  left outer join atendimento_pedido_venda apv with (nolock) on apv.cd_produto             = p.cd_produto         and
                                                                apv.cd_pedido_venda        = pvi.cd_pedido_venda  and
                                                                apv.cd_item_pedido_venda   = pvi.cd_item_pedido_venda

  --Estoque

  left outer join estoque_pedido_venda epv     with (nolock) on epv.cd_produto             = p.cd_produto         and
                                                                epv.cd_pedido_venda        = pvi.cd_pedido_venda  and
                                                                epv.cd_item_pedido_venda   = pvi.cd_item_pedido_venda
  

  --Previsao Geral

  left outer join Produto_Importacao pimp      with (nolock) on pimp.cd_produto            = p.cd_produto

  left outer join Produto_Fiscal pf            with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join Classificacao_Fiscal cf      with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  
  LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi        on nsi.cd_pedido_venda        = pvi.cd_pedido_venda      and
                                                                nsi.cd_item_pedido_venda   = pvi.cd_item_pedido_venda


where
  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end and
  isnull(pv.ic_fechado_pedido,'N')='S'                                            and  --Pedido Fechado
 --Pedido com Saldo 
  (isnull(pvi.qt_saldo_pedido_venda,0)>0                                          
   or  
   (isnull(pvi.qt_saldo_pedido_venda,0)=0 and nsi.cd_status_nota=1)                    --Notas em Aberto 
  ) 
  and pvi.dt_cancelamento_item is null                                                 --Pedido não pode estar cancelado
  --Verifica se o Pedido de Venda ( Permite Alocação )
  and isnull(tp.ic_alocacao_tipo_pedido,'S')='S'

order by
  pvi.dt_entrega_vendas_pedido,
  pv.dt_pedido_venda 


--Criação de um índice

--  Create Index IX_Analise_Alocacao on ANALISE_ALOCACAO (cd_controle)

  Create Index IX_Analise_Alocacao on #ConsultaReserva (cd_controle)

--select cd_consulta,cd_item_consulta,* from pedido_venda_item
--select cd_nota_saida,cd_item_nota_saida from pedido_venda_item
--
--   select cd_pedido_venda,
--          cd_item_pedido_venda,* 
--   from 
--     nota_saida_item i

--------------------------------------------------------------------------------------
--Verifica os Pedidos de Venda sem Saldo mas a Nota Fiscal de Saída não foi Fechada
--------------------------------------------------------------------------------------
-- delete from #ConsultaReserva 
-- where
--   qt_saldo_pedido_venda = 0   

--select * from cd_status_nota
--------------------------------------------------------------------------------------
--Deleta os Pedidos Cancelados
--------------------------------------------------------------------------------------
-- delete from #ConsultaReserva 
-- where
--   dt_cancelamento_item is not null

--------------------------------------------------------------------------------------
--Atualiza os Pedidos que Não foram Atendidos
--------------------------------------------------------------------------------------
update
  #ConsultaReserva 
  --ANALISE_ALOCACAO
set
  nm_obs_item_pedido  = case when Estoque = 'N' and Atendimento = 'N' 
                        then
                          'Verificar Item não pode ser Atendido Estoque/Previsão de Entrada'
                        else
                          case when Saldo > 0 and isnull(nm_obs_item_pedido,'')='' 
                          and Atendimento = 'N'
                          then
                            'Verificar Item não pode ser Atendido TOTALMENTE - ATENDIMENTO PARCIAL'
                          else
                            nm_obs_item_pedido
                          end
                        end

-- where
--   Estoque = 'N' and Atendimento = 'N'

--------------------------------------------------------------------------------------
--Atualiza os Pedidos que Não foram Atendidos / Parcialmente
--------------------------------------------------------------------------------------
-- update
--   --#ConsultaReserva 
--   ANALISE_ALOCACAO
-- set
--   nm_obs_item_pedido  = 'Verificar Item não pode ser Atendido TOTALMENTE - ATENDIMENTO PARCIAL'
-- where
--   Saldo > 0 and isnull(nm_obs_item_pedido,'')='' 
  --and Atendimento = 'N'

---------------------------------------------------------------------------------------
--
--Ajuste a Tabela de Consulta quando existe 02 ou mais itens alocados em um mesmo pedido + item
--
---------------------------------------------------------------------------------------

select
  cd_pedido_venda,
  cd_item_pedido_venda,
  min(cd_controle) as cd_controle,
  count(*) as qtd

into
  #GrupoReserva

from
  #ConsultaReserva
  --ANALISE_ALOCACAO

group by
  cd_pedido_venda,
  cd_item_pedido_venda

update
  #ConsultaReserva
  --ANALISE_ALOCACAO
set
  Quantidade = 0,
  Estoque    = 'N',
  QtdEstoque = 0,
  Saldo      = 0
from
  #ConsultaReserva c         with (nolock) 
  --ANALISE_ALOCACAO c           with (nolock) 
  inner join #GrupoReserva g with (nolock) on g.cd_pedido_venda         = c.cd_pedido_venda      and
                                              g.cd_item_pedido_venda = c.cd_item_pedido_venda 
  
where
 qtd>1 and
 c.cd_controle <> g.cd_controle   

-- select * from #GrupoReserva


---------------------------------------------------------------------------------------
--Mostra a Tabela Geral
---------------------------------------------------------------------------------------

select
  a.*

from 
  #ConsultaReserva a
  --ANALISE_ALOCACAO a

order by
  a.dt_entrega_vendas_pedido 

end



---------------------------------------------------------------------------------------
--Montagem da Alocação para Consulta
---------------------------------------------------------------------------------------

if @ic_parametro = 9
begin

select
  identity(int,1,1)                               as cd_controle,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  p.qt_minimo_venda_produto,
  um.sg_unidade_medida,
  pimp.cd_part_number_produto,
  fp.nm_fase_produto,
  isnull(ps.qt_saldo_reserva_produto,0)           as Disponivel,
  isnull(ps.qt_saldo_atual_produto,0)             as Atual,
  isnull(ps.qt_minimo_produto,0)                  as Minimo,
  vw.nm_destinatario                              as Cliente, 
  vw.dt_entrega_vendas_pedido                     as Entrega,
  vw.cd_documento_movimento                       as Pedido,
  vw.cd_item_documento                            as Item,
  vw.qt_movimento_estoque                         as Quantidade,
  'N'                                             as Estoque,
  cast(0.00 as float)                             as QtdEstoque,
  cast(vw.qt_movimento_estoque as float)          as Saldo,
  vw.vl_unitario_item_pedido,
  isnull(vwp.forma,apv.nm_forma)                  as forma,
  isnull(vwp.Documento,apv.cd_documento)          as Documento,
  isnull(vwp.ItemDocumento,apv.cd_item_documento) as ItemDocumento,
  vwp.Destino,
  isnull(vwp.DataPrevisao,vwe.DataPrevisao)       as DataPrevisao,

  cast(vw.dt_entrega_vendas_pedido-isnull(vwp.DataPrevisao,getdate()) as int ) as Dias,

  Entrada = ( select top 1 'S' from vw_previsao_entrada_atendimento vwe
              where
                vwe.CodigoProduto = p.cd_produto
              order by
                DataPrevisao),

  --Verifica se o Pedido está Alocado

  case when apv.qt_atendimento>0 
  then 'S'
  else 'N'
  end                                       as Atendimento,
  cast(apv.qt_atendimento as float)         as QtdAtendimento,

  ----Utilizar do Pedido de Importação + Pedido de Compra + OP

  case when vw.dt_entrega_vendas_pedido<
  (
    select
     top 1 x.DataPrevisao 
     from
       vw_previsao_entrada x with (nolock) 
     where
       x.CodigoProduto = p.cd_produto and x.DataPrevisao>=vw.dt_entrega_vendas_pedido 
       --and x.Documento not in ( select cd_documento from atendimento_pedido_venda where cd_item_documento = x.ItemDocumento ) 
     order by
        x.DataPrevisao )
  
  then 'S'
  else

   case when isnull(ps.qt_saldo_reserva_produto,0)>0 and vwp.DataPrevisao is null and isnull(ps.qt_importacao_produto,0)=0
   then 'S'
   else 'N' end

   --'N'
   
  end                                       as Utilizar,


  --Endereço do Produto
  --dbo.fn_produto_localizacao(p.cd_produto, fp.cd_fase_produto) as 'localizacao'

  cast('' as varchar(30))                   as Localizacao,

  cf.cd_mascara_classificacao,
  cf.pc_ipi_classificacao,
  cf.ic_subst_tributaria,
  cf.ic_base_reduzida,
  vw.nm_vendedor_externo,
  vw.nm_vendedor_interno,
  vw.dt_cancelamento_item

--select * from classificacao_fiscal
  
into
  #Reserva

--select * from vw_reserva_produto_estoque where cd_documento_movimento = 649262

from
  Produto p                         with (nolock) 
  left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  inner join fase_produto fp        with (nolock) on fp.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                                            then
                                                                              p.cd_fase_produto_baixa 
                                                                            else 
                                                                              @cd_fase_produto
                                                                            end

  left outer join produto_saldo ps                with (nolock) on ps.cd_produto         = p.cd_produto and
                                                                   ps.cd_fase_produto    = fp.cd_fase_produto
  --Reserva
  inner join vw_reserva_geral_produto_estoque vw        with (nolock) on vw.cd_produto         = p.cd_produto

  --Previsao de Entrada
  left outer join vw_previsao_entrega_produto vwp with (nolock) on vwp.CodigoProduto     = p.cd_produto              and
                                                                   vwp.PedidoVenda       = vw.cd_documento_movimento and
                                                                   vwp.ItemPedidoVenda   = vw.cd_item_documento         

  --select * from vw_previsao_entrega_produto where codigoproduto = 2903
                                                                   
  --Atendimento

  left outer join atendimento_pedido_venda apv with (nolock) on apv.cd_produto             = p.cd_produto              and
                                                                apv.cd_pedido_venda        = vw.cd_documento_movimento and
                                                                apv.cd_item_pedido_venda   = vw.cd_item_documento         
  
  --Previsao Geral

  left outer join vw_previsao_entrada vwe      with (nolock) on vwe.CodigoProduto          = p.cd_produto   and
                                                                vwe.Forma                  = apv.nm_forma   and
                                                                vwe.Documento              = apv.cd_documento


  left outer join Produto_Importacao pimp      with (nolock) on pimp.cd_produto            = p.cd_produto

  left outer join Produto_Fiscal pf            with (nolock) on pf.cd_produto              = p.cd_produto
  left outer join Classificacao_Fiscal cf      with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal

--select * from produto_importacao
--select * from atendimento_pedido_venda where cd_pedido_venda = 649077

where
  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end

order by
  vw.dt_entrega_vendas_pedido 


delete from #Reserva
where
  dt_cancelamento_item is not null

--select * from #Reserva

select
  *
into
  #Aux_Reserva
from
  #Reserva
where
  forma is null and
  isnull(Saldo,0) > 0  

--select * from #Aux_Reserva


--Atualiza a Quantidades de Estoque

set @qt_saldo           = 0
set @qt_movimento       = 0
set @qt_total_movimento = 0
set @ic_utilizar        = 'N'

while exists( select top 1 cd_controle from #Aux_Reserva )
begin

  select top 1
     @cd_controle        = cd_controle,
     @qt_saldo           = (Atual-@qt_total_movimento),
     @qt_movimento       = Quantidade,
     @qt_total_movimento = @qt_total_movimento + Quantidade,
     @ic_utilizar        = Utilizar
      
  from
    #Aux_Reserva
 
  order by
    Entrega

  --Atualiza o Item com Estoque = 'SIM'

  --select @cd_controle,@qt_saldo,@qt_total_movimento,@qt_movimento,@ic_utilizar
 
  if @qt_saldo>0 and @ic_utilizar = 'S' --and @qt_movimento<=@qt_saldo
  begin
    if @qt_movimento>@qt_saldo
    begin
      set @qt_movimento = @qt_saldo    
    end

    update
      #Reserva
    set
      Estoque    = 'S',
      QtdEstoque = @qt_movimento,
      Saldo      = Quantidade - @qt_movimento,
      Dias       = 0,
      Entrada    = 'N'
    where
      cd_controle = @cd_controle

  end  

  delete from #Aux_Reserva 
  where
    cd_controle = @cd_controle

  
end

--Mostra a Tabela

  select
    *
  from
    #Reserva
  order by
    Entrega

end

-------------------------------------------------------------------------------
--Programação
-------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  --print '2'
  --
  --Contrato_Fornecimento_item_mes
  --select * from Contrato_Fornecimento
  --select * from Contrato_Fornecimento_item
  --select * from Contrato_Fornecimento_item_mes

  select
    c.nm_fantasia_cliente,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    i.dt_vigencia_inicial,
    i.dt_vigencia_final,
    m.cd_ano,
    m.cd_mes,
    m.qt_contrato_fornecimento,
    m.dt_prevista_contrato,
    m.qt_liberacao,
    ve.nm_fantasia_vendedor  as nm_vendedor_externo,
    vi.nm_fantasia_vendedor  as nm_vendedor_interno


  from
    Contrato_Fornecimento_item i                     with (nolock) 
    inner join contrato_fornecimento cf              with (nolock) on cf.cd_contrato_fornecimento   = i.cd_contrato_fornecimento
    left outer join Cliente          c               with (nolock) on c.cd_cliente                  = cf.cd_cliente
    left outer join Produto      p                   with (nolock) on p.cd_produto                  = i.cd_produto
    left outer join Unidade_Medida um                with (nolock) on um.cd_unidade_medida          = p.cd_unidade_medida
    left outer join Contrato_Fornecimento_item_mes m with (nolock) on m.cd_contrato_fornecimento    = i.cd_contrato_fornecimento and
                                                                      m.cd_item_contrato            = i.cd_item_contrato
    left outer join Vendedor ve                      with (nolock) on ve.cd_vendedor                = cf.cd_vendedor
    left outer join Vendedor vi                      with (nolock) on vi.cd_vendedor                = c.cd_vendedor_interno
  

--select * from contrato_fornecimento

  where
    i.cd_produto = @cd_produto and
    isnull(m.qt_liberacao,0) <= isnull(m.qt_contrato_fornecimento,0)
  order by
    m.cd_ano,
    m.cd_mes
    
end

-------------------------------------------------------------------------------
--Previsão de Entrada
-------------------------------------------------------------------------------

if @ic_parametro = 3
begin

--  print '3'

  select 
    vwe.*,

--    Saldo = vwe.QtdLiquida,

    Saldo = vwe.Quantidade - isnull(( select sum(isnull(apv.qt_atendimento,0)) 
                               from Atendimento_Pedido_Venda apv with (nolock) 
                               where
                                 vwe.Documento     = apv.cd_documento      and 
                                 vwe.ItemDocumento = apv.cd_item_documento and
                                 vwe.CodigoProduto = apv.cd_produto ),0),

    Utilizado = isnull(( select sum(isnull(apv.qt_atendimento,0)) 
                               from Atendimento_Pedido_Venda apv with (nolock) 
                               where
                                 vwe.Documento     = apv.cd_documento      and 
                                 vwe.ItemDocumento = apv.cd_item_documento and
                                 vwe.CodigoProduto = apv.cd_produto ),0)

  from 
    vw_previsao_entrada vwe with (nolock) 
  where
    vwe.codigoproduto = @cd_produto

  order by
    vwe.DataPrevisao 

--select * from vw_previsao_entrada
--select * from atendimento_pedido_venda 
--select * from atendimento_pedido_venda where cd_produto = 2903
--select * from vw_previsao_entrada where codigoProduto = 2903

end

-------------------------------------------------------------------------------
--Atendimento
-------------------------------------------------------------------------------

if @ic_parametro = 4
begin

--  print '4'

  select 
    c.nm_fantasia_cliente,
    a.*,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    vw.Quantidade,
    vw.DataPrevisao,
    ve.nm_fantasia_vendedor  as nm_vendedor_externo,
    vi.nm_fantasia_vendedor  as nm_vendedor_interno


  from 
    atendimento_pedido_venda a             with (nolock) 
    left outer join pedido_venda pv        with (nolock) on pv.cd_pedido_venda   = a.cd_pedido_venda
    left outer join Cliente      c         with (nolock) on c.cd_cliente         = pv.cd_cliente
    left outer join Produto      p         with (nolock) on p.cd_produto         = a.cd_produto
    left outer join Unidade_Medida um      with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join vw_previsao_entrada vw with (nolock) on vw.CodigoProduto     = a.cd_produto and
                                                            vw.Forma             = a.nm_forma   and
                                                            vw.Documento         = a.cd_documento
    left outer join Vendedor ve            with (nolock) on ve.cd_vendedor                = pv.cd_vendedor
    left outer join Vendedor vi            with (nolock) on vi.cd_vendedor                = pv.cd_vendedor_interno

  where
    a.cd_produto = @cd_produto

  order by
    a.dt_atendimento

end


