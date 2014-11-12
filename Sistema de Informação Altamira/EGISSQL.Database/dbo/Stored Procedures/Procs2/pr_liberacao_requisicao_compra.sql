
---------------------------------------------------------------------------------------------------
--pr_liberacao_requisicao_compra
---------------------------------------------------------------------------------------------------
-- GBS - Global Business Solution	             2003
-- Stored Procedure	: Microsoft SQL Server       2000
-- Autor(es)	        : Daniel C. Neto.
-- Banco de Dados	: EGISSQL
-- Objetivo		: Fazer liberação da Requisição de Compra
-- Data			: 27/01/2003
-- Atualizacao          : 19/05/2003 - Filtro por Departamento de Requisicao do usuario no Parametro 1
--                        20/05/2003 - Atualização da Rotina do Parametro 3
-- 11/09/2003 - Nova consistência para verificar se a requisição está em aberto - Daniel C. Neto.
-- 05/02/2005 - Acertos Gerais - Carlos Fernandes
-- 16.02.2005 - Checa o flag na tabela de Departamento_Aprovacao, se o flag ic_aprova_requisicao=´S´
--              Carlos Fernandes
-- 17.08.2010 - AJUSTES diversos - Carlos Fernandes
---------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_liberacao_requisicao_compra
@ic_parametro         int,
@cd_req_compra        int,
@ic_tipo_aprovacao    char(1), -- A para aprovado, R para reprovado
@nm_obs_usu_aprovacao varchar(40),
@cd_usuario           int

AS

begin transaction

declare @Tipo_da_requisicao        char (1)
declare @ic_ass_eletronica_usuario char(1)
declare @cd_tipo_aprovacao         int
declare @cd_item_aprov_requisicao  int

set @Tipo_da_requisicao        = '' 
set @ic_ass_eletronica_usuario =''

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Requisição Compras (Todos)
-------------------------------------------------------------------------------
  begin

    select 
      @ic_ass_eletronica_usuario = isnull(ic_ass_eletronica_usuario,'N'),
      @cd_tipo_aprovacao         = cd_tipo_aprovacao
    from
      egisadmin.dbo.usuario with (nolock) 
    where
      cd_usuario = @cd_usuario

 
    --Mensagem para O usuário
    if isnull(@ic_ass_eletronica_usuario,'N')='N'
    begin
      raiserror('Usuário não autorizado para Liberação Eletrônica da Requisição de Compra!', 16, 1)
      goto TrataErro
    end
      select 
        0 as 'Sel',
        rc.cd_requisicao_compra,
        rc.dt_emissao_req_compra,
        rc.dt_necessidade_req_compra,
        cast (rc.ds_requisicao_compra as varchar(255)) as ds_requisicao_compra,
        rc.cd_usuario,
        rc.dt_usuario,
        rc.cd_status_requisicao,
        tr.ic_tipo_requisicao,
        rc.cd_item_pedido_compra,
        rc.ic_aprovada_req_compra,
        rc.ic_reprovada_req_compra,
        ap.nm_aplicacao_produto,
        plc.nm_plano_compra,
        plc.cd_mascara_plano_compra,
        cc.nm_centro_custo,
        dp.nm_departamento,
        tr.nm_tipo_requisicao,
        usuario.nm_fantasia_usuario,
        rc.cd_pedido_compra
      from Requisicao_compra rc with (nolock) 
      Left outer join Requisicao_Compra_Aprovacao rca on 
        rca.cd_requisicao_compra = rc.cd_requisicao_compra  
      left outer join egisadmin.dbo.usuario  usuario on 
        usuario.cd_usuario=rc.cd_usuario       
      left outer join Aplicacao_produto ap on 
        ap.cd_aplicacao_produto=rc.cd_aplicacao_produto 
      left outer join Centro_custo cc on 
        cc.cd_centro_custo=rc.cd_centro_custo           
      left outer join  Departamento dp  on 
        dp.cd_departamento=rc.cd_departamento           
      left outer join tipo_requisicao tr on 
        rc.cd_tipo_requisicao=tr.cd_tipo_requisicao     
      left outer join plano_compra plc on 
        plc.cd_plano_compra=rc.cd_plano_compra          
      where 
        ((@cd_req_Compra = 0) or (rc.cd_requisicao_compra = @cd_req_Compra)) and
        rc.cd_status_requisicao = 1 and
        IsNull(rc.ic_liberado_proc_compra, 'N') = 'S'  and
        (isNull(rc.ic_aprovada_req_compra,'N')  = 'N') and 
        (isNull(rc.ic_reprovada_req_compra,'N') = 'N') and
        (isnull(rca.cd_tipo_aprovacao,0) <> @cd_tipo_aprovacao and
        (exists(select distinct
                  da.cd_tipo_aprovacao
                from
                  departamento_aprovacao 	da with (nolock) 
                left outer join egisadmin.dbo.usuario	ua  on 
                  ua.cd_departamento = da.cd_departamento and ua.cd_tipo_aprovacao=da.cd_tipo_aprovacao
                  and isnull(da.ic_aprova_requisicao,'N')='S'
                where
                  ua.cd_usuario=@cd_usuario))) and
        rc.cd_departamento = usuario.cd_departamento
      order by 
        tr.qt_prior_tipo_requisicao,
	      rc.dt_necessidade_req_compra,
        rc.dt_emissao_req_compra,
        rc.cd_requisicao_compra   
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- Consulta de Itens de Requisição Compra
--------------------------------------------------------------------------------
begin 

  SELECT     
    rci.cd_item_requisicao_compra, 
    rci.nm_prod_requisicao_compra,
	  rci.cd_mascara_produto, 
	  m.nm_fantasia_maquina, 
	  rci.qt_item_requisicao_compra, 
    um.sg_unidade_medida, 
	  rci.dt_item_nec_req_compra, 
	  rci.cd_pedido_venda, 
	  rci.cd_item_pedido_venda, 
	  rci.qt_liquido_req_compra, 
    rci.qt_bruto_req_compra, 
	  rci.ds_item_requisicao_compra, 
	  rci.nm_marca_item_req_compra, 
	  c.nm_fantasia_cliente, 
	  rci.ds_obs_req_compra_item, 
	  rci.cd_mat_prima,
	  rci.nm_medacab_mat_prima,
    rci.nm_medbruta_mat_prima,
    rci.cd_tipo_placa
  FROM 
    Requisicao_Compra_Item rci with (nolock) 
  left outer join Maquina m ON 
    rci.cd_maquina = m.cd_maquina 
  left outer join Unidade_Medida um ON 
    rci.cd_unidade_medida = um.cd_unidade_medida 
  left outer join Pedido_Venda pv ON 
    rci.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join Cliente c ON 
    pv.cd_cliente = c.cd_cliente
  where      
    cd_requisicao_compra = @cd_req_compra

end

---------------------------------------------------------------------
else if @ic_parametro = 3 -- Atualiza a Aprovacao da Requisicao de Compra
---------------------------------------------------------------------
begin

  set @cd_tipo_aprovacao = ( select cd_tipo_aprovacao 
                             from EGISADMIN.dbo.Usuario with (nolock) 
                             where cd_usuario = @cd_usuario )

  set @cd_item_aprov_requisicao = ( select isnull(max(cd_item_aprov_requisicao),0)+1
                                  from Requisicao_Compra_Aprovacao
                                  where cd_requisicao_compra=@cd_req_compra)
  if @cd_tipo_aprovacao is null
    begin
      raiserror('Usuário não tem um tipo de aprovação válido cadastrado!', 16, 1)
      goto TrataErro
    end


  insert into Requisicao_Compra_Aprovacao ( 
    cd_requisicao_compra,
    cd_item_aprov_requisicao,
    cd_tipo_aprovacao,
    ic_tipo_aprovacao, 
    cd_usuario_aprovacao,
    dt_usuario_aprovacao,
    nm_obs_usu_aprovacao,
    cd_usuario,
    dt_usuario )
  values 
    ( @cd_req_compra,
      @cd_item_aprov_requisicao,
      @cd_tipo_aprovacao,
      @ic_tipo_aprovacao,
      @cd_usuario,
      GetDate(),
      @nm_obs_usu_aprovacao,
      @cd_usuario,
      GetDate()  )

  if (@ic_tipo_aprovacao = 'A') and
     (select count(
             rca.ic_tipo_aprovacao)
           from
             departamento_aprovacao 	da 
           left outer join requisicao_compra rc  on 
             da.cd_departamento = rc.cd_departamento 
           left outer join requisicao_compra_aprovacao 	rca on 
             rc.cd_requisicao_compra = rca.cd_requisicao_compra and da.cd_tipo_aprovacao = rca.cd_tipo_aprovacao 
           left outer join egisadmin.dbo.usuario	ua  on 
             rca.cd_usuario_aprovacao = ua.cd_usuario
           where
             rc.cd_requisicao_compra = @cd_req_compra and
             rca.ic_tipo_aprovacao='A' --Número de Aprovações já feitas 
--Carlos 16.02.2005
             and
             isnull(da.ic_aprova_requisicao,'N')='S' )
     = (select count(
             rc.cd_departamento)
           from
             departamento_aprovacao 	da 
           left outer join requisicao_compra rc  on 
             da.cd_departamento = rc.cd_departamento 
           left outer join egisadmin.dbo.usuario	ua  on 
             rc.cd_usuario = ua.cd_usuario
           where
             rc.cd_requisicao_compra = @cd_req_compra  
             and
             isnull(da.ic_aprova_requisicao,'N')='S' )
                                                        --Número necessária de Aprovações
 

    update Requisicao_Compra
    set ic_aprovada_req_compra  = 'S',
        ic_reprovada_req_compra = 'N'
    where cd_requisicao_compra  = @cd_req_compra

  else if (@ic_tipo_aprovacao='R')
    update Requisicao_Compra
    set ic_reprovada_req_compra = 'S',
        ic_aprovada_req_compra  = 'N'
    where cd_requisicao_compra  = @cd_req_compra

end


--Confima Transação Caso Não Tenha Ocorrido Nenhum Erro
TrataErro:
  if @@Error = 0
    commit transaction
  else
    rollback transaction

