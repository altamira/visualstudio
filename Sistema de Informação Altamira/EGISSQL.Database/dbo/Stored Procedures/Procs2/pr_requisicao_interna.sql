

CREATE PROCEDURE pr_requisicao_interna
-------------------------------------------------------------------------------
--pr_requisicao_interna
-------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA	                                   2004
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Daniel Duela
--Banco de Dados         : EgisSQL
--Objetivo               : Consulta de Requisição Interna
--Data                   : 12/03/2002
--Atualizado             : 20/06/2002
--                       : 29/01/2003 - Daniel C. Neto.
--                       : 04/04/2003 - Daniel C. Neto.
--   		         : 17/06/2003 - Rafael M. Santiago - Colocado Filtro da Requisição por periodo e por 
--                                      numero de requisicao
--                       : 01/06/2003 - Incluída coluna de Saldo Disponível - Daniel C. Neto.
--                       : 04/03/2004 - Incluída nova filtragem de registros (Em aberto/Baixado/Todos) - DANIEL DUELA
--                       : 30.04.2004 - Inclusão de filto por usuário e usuário que dá baixa na requisição - Igor Gama
--                       : 06.05.2004 - Inclusão de campo de Saldo atual - Igor Gama.
--                       : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 13/05/2005 - Valor Default para a variavel @ic_status - Márcio		       
--                       : 31.08.2005 - Novos atributos para controle de liberação para baixa de estoque - Carlos Fernandes.
--                                    - Novos atributos : Pedido de Venda / Item do Pedido de Venda
--                       : 27.03.2006 - Inclusão dos campos Cliente e Historico Estoque : Lucio  
--                       : 12.03.2007 - Inclusão do Motivo da RI. - Anderson
--                       : 17.10.2007 - Acerto de Pesquisa - Carlos Fernandes
-- 03.01.2008 - Mostrar o Número do Lançamento de Estoque - Carlos Fernandes
-- 13.06.2008 - Acerto do Número da Documento do movimento - Carlos Fernandes
-- 07.10.2008 - Na deleção ajustar o Saldo dos Produtos - Carlos Fernandes
-- 06.12.2008 - Ajustes Diversos - Colocação da Coluna Saldo - Carlos Fernandes
-- 10.12.2008 - Cancelamento da RI, zerar a composição do Processo - Carlos Fernandes
-- 08.09.2010 - Novos Atributos - Carlos Fernandes
-- 10.11.2010 - Status da Requisição - Carlos Fernandes
-- 29.11.2010 - Número da Proposta Comercial - Carlos Fernandes
-- 17.01.2011 - Posição da Separação - Carlos Fernandes
-- 18.01.2011 - Pesquisa por Pedido/OP/Lote - Carlos Fernandes
-- 21.01.2011 - Baixa Parcial - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------------------
@ic_parametro          int      = 0 , 
@ic_status             char(1)  = 'T',
@cd_requisicao_interna int      = 0,
@dt_inicial            datetime = '',
@dt_final              datetime = '',
@cd_usuario            int      = 0,
@dt_usuario            datetime = null,
@cd_processo           int         = 0,
@cd_pedido_venda       int         = 0,
@cd_lote_produto       varchar(25) = '',
@cd_posicao_separacao  varchar(15) = ''


as

-------------------------------------------------------------------------------
if @ic_parametro in (1,2)     -- Consulta de Requisição Interna
-------------------------------------------------------------------------------
Begin

  Declare @ic_supervisor char(1), @ic_permissao_baixa char(1)

  Select 
    --Verifica se o usuário é supervisor
    @ic_supervisor = IsNull(ic_tipo_usuario,'P'),
    --Verifica se o usuário tem permição para realizar a baixa na requisição
    @ic_permissao_baixa = IsNull(ic_bx_req_interna_usuario,'N')
  from 
    EgisAdmin.dbo.Usuario with (nolock) 
  Where 
    cd_usuario = @cd_usuario


  select 
    ri.cd_requisicao_interna,
    ri.dt_requisicao_interna,
    ri.dt_necessidade,
    ri.cd_departamento,
    dp.nm_departamento,
    ri.cd_centro_custo,
    cc.nm_centro_custo,
    ri.cd_aplicacao_produto,
    ap.nm_aplicacao_produto,
    ri.ds_requisicao_interna,
    ri.cd_usuario,
    ri.dt_usuario,
    ri.cd_usuario_requisicao,
    u.nm_fantasia_usuario,
    ri.dt_estoque_req_interna,
    ri.ic_maquina,
    --ri.cd_usuario_requisicao,
    ri.ic_lib_estoque_requisicao,
    ri.dt_lib_estoque_requisicao,
    cast(null as varchar(15)) as Cliente,
    0                         as CodHistEstoque,
    ri.cd_motivo_req_interna,
    mri.nm_motivo_req_interna,
    ri.cd_funcionario,
    f.nm_funcionario,
    ri.cd_status_requisicao,
    sr.nm_status_requisicao,
    ri.cd_consulta,
    ri.cd_posicao_separacao


  into
    #RequisicaoInterna

  from 
    Requisicao_Interna ri                        with (nolock) 
    left outer join Departamento dp              with (nolock) on dp.cd_departamento        = ri.cd_departamento
    left outer join Centro_Custo cc              with (nolock) on cc.cd_centro_custo        = ri.cd_centro_custo
    left outer join Aplicacao_Produto ap         with (nolock) on ap.cd_aplicacao_produto   = ri.cd_aplicacao_produto  
    left outer join EgisAdmin.dbo.Usuario u      with (nolock) on u.cd_usuario              = ri.cd_usuario
    left outer join Motivo_Req_Interna mri       with (nolock) on mri.cd_motivo_req_interna = ri.cd_motivo_req_interna
    left outer join Funcionario        f         with (nolock) on f.cd_funcionario          = ri.cd_funcionario
    left outer join Status_Requisicao_Interna sr with (nolock) on sr.cd_status_requisicao   = ri.cd_status_requisicao

  where 
    (ri.cd_requisicao_interna       = case when @cd_requisicao_interna=0 then ri.cd_requisicao_interna else @cd_requisicao_interna end ) and
    (ri.dt_requisicao_interna between case when @cd_requisicao_interna=0 then @dt_inicial              else ri.dt_requisicao_interna end and @dt_final) and
    ((@ic_status = 'T') or (@ic_status = 'B' and ri.dt_estoque_req_interna is not null) or
     (@ic_status = 'T') or (@ic_status = 'P' and ri.dt_estoque_req_interna is not null) or
     (@ic_status = 'A' and ri.dt_estoque_req_interna is null)) and
    (ri.cd_usuario_requisicao = 
       --Não sei o motivo de haver duas consultas identicas que possuem apenas verificação de usuário,
       -- então deixei apenas uma consulta para motivos de alteração das mesmas. Sendo que o parametro 1 não
       -- utiliza o filtro de usuario e os demais utilizam. Igor Gama - 30.04.2004
       case When @ic_parametro = 1 then ri.cd_usuario_requisicao
            Else
            case When @ic_supervisor = 'S' then ri.cd_usuario_requisicao
                 Else case When @ic_permissao_baixa = 'S' then ri.cd_usuario_requisicao
                           Else @cd_usuario end end end)


  
    
  order by 
    ri.dt_requisicao_interna desc, 
    ri.cd_requisicao_interna desc



  --Mostra todos os Registros----------------------------------------------------------

  if isnull(@cd_pedido_venda,0) = 0 and isnull(@cd_processo,0) = 0 and isnull(@cd_lote_produto,'') = '' and
     isnull(@cd_posicao_separacao,'') = ''
  begin
    select
      ri.*
    from
      #RequisicaoInterna ri
  
    order by 
      ri.dt_requisicao_interna desc, 
      ri.cd_requisicao_interna desc
  end

  --Pedido de Venda

  if @cd_pedido_venda <> 0 
  begin

    select
      ri.*
    from
      #RequisicaoInterna ri
    where
      ri.cd_requisicao_interna in ( select i.cd_requisicao_interna 
                                    from
                                       requisicao_interna_item i
                                    where
                                       i.cd_requisicao_interna     = ri.cd_requisicao_interna and
                                       isnull(i.cd_pedido_venda,0) = @cd_pedido_venda )
 
    order by 
      ri.dt_requisicao_interna desc, 
      ri.cd_requisicao_interna desc

  end


  --Ordem de Produção------------------------------\

  if @cd_processo <> 0 
  begin

    select
      ri.*
    from
      #RequisicaoInterna ri
    where
      ri.cd_requisicao_interna in ( select i.cd_requisicao_interna 
                                    from
                                       requisicao_interna_item i
                                    where
                                       i.cd_requisicao_interna     = ri.cd_requisicao_interna and
                                       isnull(i.cd_processo,0) = @cd_processo )
 
    order by 
      ri.dt_requisicao_interna desc, 
      ri.cd_requisicao_interna desc

  end

  --Lote de Produto
  -------------------------------------------------------------------------

  if @cd_lote_produto <> ''
  begin

    select
      ri.*
    from
      #RequisicaoInterna ri
    where
      ri.cd_requisicao_interna in ( select i.cd_requisicao_interna 
                                    from
                                       requisicao_interna_item i
                                    where
                                       i.cd_requisicao_interna     = ri.cd_requisicao_interna and
                                       isnull(i.cd_lote_produto,'') = @cd_lote_produto )
 
    order by 
      ri.dt_requisicao_interna desc, 
      ri.cd_requisicao_interna desc

  end


  --posicao de separação
  -------------------------------------------------------------------------

  if @cd_posicao_separacao <> ''
  begin

    select
      ri.*
    from
      #RequisicaoInterna ri
    where
      ri.cd_requisicao_interna in ( select i.cd_requisicao_interna 
                                    from
                                       requisicao_interna i
                                    where
                                       i.cd_requisicao_interna           = ri.cd_requisicao_interna and
                                       isnull(i.cd_posicao_separacao,'') = @cd_posicao_separacao )
 
    order by 
      ri.dt_requisicao_interna desc, 
      ri.cd_requisicao_interna desc

  end



end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta dos Itens de Requisição Interna
-------------------------------------------------------------------------------
begin

  --select * from tipo_movimento_estoque
  --select * from tipo_documento_estoque
  --select * from movimento_estoque where cd_documento_movimento = 2
  --select * from requisicao_interna_item

  select 
    rii.cd_requisicao_interna,
    rii.cd_item_req_interna,
    rii.cd_produto,
    case when rii.cd_produto is null then '' else rii.nm_produto_req_interna end 'nm_produto_req_interna',
    rii.nm_servico_req_interna,
    rii.cd_servico,
    rii.ic_estoque_req_interna,
    rii.cd_unidade_medida,
    rii.ds_requisicao_interna,
    rii.qt_item_req_interna,

    case when isnull(rb.qt_baixa_requisicao,0)>0 then
       rb.qt_baixa_requisicao
    else
      case when isnull(rii.qt_entregue_req_interna,0)>0 
      then
         rii.qt_entregue_req_interna
      else
         rii.qt_item_req_interna
      end 
    end                                                             as qt_entregue_req_interna,

    --Saldo------------------------------------------------------------------------------------
 
    rii.qt_item_req_interna - 
    case when isnull(rb.qt_baixa_requisicao,0)>0 then
       rb.qt_baixa_requisicao
    else         
       isnull(rii.qt_entregue_req_interna,0)
    end                                                             as qt_saldo_req_interna,

    isnull(rb.qt_baixa_requisicao,0)                                as qt_baixa_requisicao,


    rii.nm_obs_req_interna,
    rii.ic_estoque_req_interna,
    rii.cd_usuario,
    rii.dt_usuario,
    rii.dt_item_estoque_req,
    rii.nm_item_requisicao,
    rii.qt_item_requisicao,

    case when isnull(rii.qt_entregue_item,0)>0
    then
       rii.qt_entregue_item
    else
       isnull(rii.qt_item_requisicao,0)
    end                                   as qt_entregue_item,

    IsNull(rii.ic_estoque_requisicao,'N') as 'ic_estoque_requisicao',
    case when rii.cd_produto is null then rii.nm_produto_req_interna else '' end 'nm_produto_especial',
    rii.cd_fase_produto,
    ps.qt_saldo_reserva_produto,
    ps.qt_saldo_atual_produto,
    rii.cd_mascara_produto,
    rii.cd_maquina,
    rii.cd_pedido_venda,
    rii.cd_item_pedido_venda,
    cast(cl.nm_fantasia_cliente as varchar(15)) as Cliente,
    rii.cd_historico_estoque as CodHistEstoque, -- A ser preenchido no "form"
    rii.cd_lote_produto,
    isnull(( select top 1 isnull(cd_movimento_estoque,0) from movimento_estoque
      where cd_documento_movimento = cast(rii.cd_requisicao_interna as varchar(20))
            and cd_tipo_documento_estoque = 5 ),0) as cd_movimento_estoque,
    isnull(rii.ic_transferencia,'N')               as ic_transferencia,
    isnull(rii.cd_plano_mrp,0)                     as cd_plano_mrp,
    isnull(rii.cd_processo,0)                      as cd_processo,
    rii.cd_funcionario,
    f.nm_funcionario

  from 
    Requisicao_Interna_Item rii      with (nolock)
    left outer join Pedido_Venda pv  with (nolock) on rii.cd_pedido_venda = pv.cd_pedido_venda
    left outer join Cliente cl       with (nolock) on pv.cd_cliente       = cl.cd_cliente
    left outer join Produto_Saldo ps with (nolock) on ps.cd_produto       = rii.cd_produto and
                                                      ps.cd_fase_produto  = rii.cd_fase_produto
    left outer join funcionario   f  with (nolock) on f.cd_funcionario    = rii.cd_funcionario
    left outer join vw_baixa_requisicao_interna rb with (nolock) on rb.cd_requisicao_interna = rii.cd_requisicao_interna and
                                                                    rb.cd_item_req_interna   = rii.cd_item_req_interna
  where 
    rii.cd_requisicao_interna = @cd_requisicao_interna

  order by 
    rii.cd_item_req_interna 

end

-------------------------------------------------------------------------------
if @ic_parametro = 9    -- Deleta todos Itens de Requisição Interna
-------------------------------------------------------------------------------
begin

  --select * from tipo_movimento_estoque
  --select * from tipo_documento_estoque

  --Ajusta o Saldo ds Produtos da Requisição

  declare @cd_produto             int
  declare @qt_item_req_interna    float 
  declare @cd_fase_produto        int
  declare @ic_estoque_req_interna char(1) 

  select
    cd_requisicao_interna,
    cd_produto,
    qt_item_req_interna,
    cd_fase_produto,
    isnull(ic_estoque_req_interna,'N') as ic_estoque_req_interna
    
  into
    #ItemRequisicaoSaldo

  from
    requisicao_interna_item with (nolock) 

  where
    cd_requisicao_interna = @cd_requisicao_interna and
    isnull(cd_produto,0)>0                         and
    isnull(qt_item_req_interna,0)>0

  while exists ( select top 1 cd_produto from #ItemRequisicaoSaldo )
  begin

    select top 1 
      @cd_produto             = cd_produto,
      @qt_item_req_interna    = qt_item_req_interna,
      @cd_fase_produto        = cd_fase_produto,
      @ic_estoque_req_interna = ic_estoque_req_interna
    from
      #ItemRequisicaoSaldo 

    --Ajusta o Saldo do Produto

   --Reserva

   exec pr_Movimenta_estoque  
        3,                       --Acerto do Saldo do Produto
        3,                       --Tipo de Movimentação de Estoque ( Reserva )
        NULL,                    --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_item_req_interna,    --Quantidade
        NULL,                    --Quantidade Antiga
        null,                    --Data do Movimento de Estoque
        null,                    --Pedido de Venda
        null,                    --Item do Pedido
        7,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        null,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        null,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
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
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão


    if @ic_estoque_req_interna='S' 
    begin
      exec pr_Movimenta_estoque  
        3,                       --Acerto do Saldo do Produto
        1,                       --Tipo de Movimentação de Estoque ( Real )
        NULL,                    --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_item_req_interna,    --Quantidade
        NULL,                    --Quantidade Antiga
        null,                    --Data do Movimento de Estoque
        null,                    --Pedido de Venda
        null,                    --Item do Pedido
        7,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        null,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        NULL,                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        null,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
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
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
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

    delete from #ItemRequisicaoSaldo 
    where
      cd_requisicao_interna = @cd_requisicao_interna and
      cd_produto            = @cd_produto

  end

--select * from requisicao_interna_item

  --Atualiza os Itens do Projeto / Lista de Material

  --select * from projeto_composicao_material
  update
    Projeto_Composicao_Material
  set
    cd_requisicao_interna  = 0,
    cd_item_req_interna    = 0
  where
    cd_requisicao_interna  = @cd_requisicao_interna    
  
  --Atualiza os Itens da Composição do Processo de Produção

  update
    processo_producao_componente
  set
    cd_requisicao_interna  = 0,
    cd_item_req_interna    = 0
  where
    cd_requisicao_interna  = @cd_requisicao_interna    

  --Itens da Requisição Interna
  delete from requisicao_interna_item where cd_requisicao_interna     = @cd_requisicao_interna

  --Requisição Interna 
  delete from requisicao_interna      where cd_requisicao_interna     = @cd_requisicao_interna

  --Movimento de Estoque
  delete from movimento_estoque       where cd_documento_movimento    = @cd_requisicao_interna and
                                            cd_tipo_documento_estoque = 5 
end

