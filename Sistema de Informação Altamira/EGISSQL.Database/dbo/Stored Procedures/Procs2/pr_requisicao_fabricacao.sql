

CREATE PROCEDURE pr_requisicao_fabricacao
-------------------------------------------------------------------------------
--pr_requisicao_fabricacao
-------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA	                                   2005
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Carlos Cardoso Fernandes
--Banco de Dados         : EgisSQL
--Objetivo               : Consulta de Requisição Fabricação
--Data                   : 12/03/2002
--Atualizado             : 20/06/2002
--                       : 05.11.2005 - Revisão Geral - Carlos Fernandes
-- 25.05.2010 - 
-----------------------------------------------------------------------------------------------------------------------------
@ic_parametro             int      = 0, 
@ic_status                char(1)  = 'T',
@cd_requisicao            int      = 0,
@dt_inicial               datetime = null,
@dt_final                 datetime = null,
@cd_usuario               int      =0,
@dt_usuario               datetime = null

as

-------------------------------------------------------------------------------
if @ic_parametro in (1,2)     -- Consulta de Requisição 
-------------------------------------------------------------------------------
Begin

  Declare @ic_supervisor char(1), @ic_permissao_baixa char(1)

  Select 
    --Verifica se o usuário é supervisor
    @ic_supervisor = IsNull(ic_tipo_usuario,'P'),
    --Verifica se o usuário tem permição para realizar a baixa na requisição
    @ic_permissao_baixa = IsNull(ic_bx_req_fab_usuario,'N')
  from EgisAdmin.dbo.Usuario Where cd_usuario = @cd_usuario


  select 
    rf.cd_requisicao,
    rf.dt_requisicao,
    rf.dt_necessidade,
    rf.cd_departamento,
    dp.nm_departamento,
    rf.cd_centro_custo,
    cc.nm_centro_custo,
    rf.cd_aplicacao_produto,
    ap.nm_aplicacao_produto,
    rf.ds_requisicao,
    rf.cd_usuario,
    rf.dt_usuario,
    rf.cd_usuario_requisicao,
    u.nm_fantasia_usuario,
    rf.dt_estoque_req_fabricacao,
    rf.ic_liberada_requisicao,
    rf.dt_liberacao_requisicao,
    isnull(rf.ic_lib_estoque_req_fabricacao,'N') as ic_lib_estoque_req_fabricacao

--select * from requisicao_fabricacao

  from 
    requisicao_fabricacao rf with (nolock) 
    left outer join 
    Departamento dp 
      on dp.cd_departamento=rf.cd_departamento
      left outer join 
    Centro_Custo cc 
      on cc.cd_centro_custo = rf.cd_centro_custo
      left outer join 
    Aplicacao_Produto ap 
      on ap.cd_aplicacao_produto = rf.cd_aplicacao_produto  
      left outer join 
    EgisAdmin.dbo.Usuario u 
      on u.cd_usuario = rf.cd_usuario
  where 
    (rf.cd_requisicao = @cd_requisicao or @cd_requisicao = 0) and
    (rf.dt_requisicao between @dt_inicial and @dt_final) and
    ((@ic_status = 'T') or (@ic_status = 'B' and rf.dt_estoque_req_fabricacao is not null) or
     (@ic_status = 'A' and rf.dt_estoque_req_fabricacao is null)) and
    (rf.cd_usuario_requisicao = 
       --Não sei o motivo de haver duas consultas identicas que possuem apenas verificação de usuário,
       -- então deixei apenas uma consulta para motivos de alteração das mesmas. Sendo que o parametro 1 não
       -- utiliza o filtro de usuario e os demais utilizam. Igor Gama - 30.04.2004
       case When @ic_parametro = 1 then rf.cd_usuario_requisicao
            Else
            case When @ic_supervisor = 'S' then rf.cd_usuario_requisicao
                 Else case When @ic_permissao_baixa = 'S' then rf.cd_usuario_requisicao
                           Else @cd_usuario end end end)
  order by 
    rf.dt_requisicao desc, rf.cd_requisicao desc
end

--select * from requisicao_fabricacao

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta dos Itens de Requisição Interna
-------------------------------------------------------------------------------
begin
  select 
    rfi.cd_requisicao,
    rfi.cd_item_requisicao,
    rfi.cd_produto,
    case when rfi.cd_produto is null then '' else rfi.nm_produto_requisicao end 'nm_produto_req_fabricacao',
    rfi.ic_estoque_req_fabricacao,
    rfi.cd_unidade_medida,
    rfi.ds_item_req_fabricacao,
    rfi.qt_item_requisicao,   
    rfi.qt_fabricada_req_fab,
    rfi.nm_obs_item_req_fab,
    rfi.cd_usuario,
    rfi.dt_usuario,
    rfi.dt_item_estoque_req,
    rfi.nm_produto_requisicao,
    IsNull(rfi.ic_estoque_requisicao,'N') as 'ic_estoque_requisicao',
    case when rfi.cd_produto is null then rfi.nm_produto_requisicao else '' end 'nm_produto_especial',
    rfi.cd_fase_produto,
    ps.qt_saldo_reserva_produto,
    ps.qt_saldo_atual_produto,
    rfi.cd_mascara_produto,
    rfi.cd_pedido_venda,
    rfi.cd_item_pedido_venda

  from 
    requisicao_fabricacao_Item rfi 
      left outer join 
    Produto_Saldo ps 
      on ps.cd_produto = rfi.cd_produto and 
         ps.cd_fase_produto = rfi.cd_fase_produto
  where 
    rfi.cd_requisicao = @cd_requisicao
  order by 
    rfi.cd_item_requisicao
end

