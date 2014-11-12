
CREATE PROCEDURE pr_consulta_produto_requisicao_compra
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Requisições por Produto.
--Data          : 16/06/2003
--              : 01/07/2003 - Incluído novo parâmetro para filtrar por todas as 
--                             requisições ou somente as em aberto - Daniel C. Neto.
--              : 30/10/2003 - Filtro por Cotação e por Pedido - Daniel C. NEto.
--                25/02/2004 - Incluído colunas de Pedido de Importação.
--                           - Daniel C. Neto.
--                05/12/2005 - Acerto para Mostrar como RC em Aberto mesmo as que
--                             Estiverem em Cotação, mas não transformadas em PC - ELIAS
--                24/01/2006 - Ajuste para verificar o preenchimento do PC no item da RC
--                             e não no cabeçalho da RC. - ELIAS
--                31/05/2006 - Pesquisa por Descrição do Produto - Márcio
--                21/07/2006 - Adição de "With (nolock)" e indices diretos para melhoria da performance - Fabio Cesar
---------------------------------------------------

@ic_parametro        int,
@nm_fantasia_produto varchar(30),
@ic_tipo_requisicao  char(1) = 'T'


AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Produto por Nome Fantasia
-------------------------------------------------------------------------------
  begin
    select 
       ri.cd_produto,
       ri.cd_pedido_venda,
       p.cd_mascara_produto,
       p.nm_produto,
       gp.cd_mascara_grupo_produto,
       ri.nm_prod_requisicao_compra,
       ri.ds_item_requisicao_compra,
       ri.cd_requisicao_compra,
       r.dt_emissao_req_compra,
       ri.dt_item_nec_req_compra as dt_necessidade_req_compra,
       cast(r.dt_necessidade_req_compra as integer) - cast(GetDate() as integer) as 'Dias',
       ri.cd_item_requisicao_compra,
       ri.qt_item_requisicao_compra,
       us.nm_fantasia_usuario,
       dp.nm_departamento,
       ri.cd_item_ped_imp,
       ri.cd_pedido_importacao,
       pci.cd_item_pedido_compra,
       pc.cd_pedido_compra
    from 
      Requisicao_Compra r with (nolock) inner join
      Requisicao_Compra_Item ri with (nolock, index(PK_Requisicao_Compra_Item)) on r.cd_requisicao_compra=ri.cd_requisicao_compra left outer join
      Departamento dp with (nolock, index(PK_Departamento)) on dp.cd_departamento = r.cd_departamento left outer join
      Produto p with (nolock, index(PK_Produto)) on p.cd_produto = ri.cd_produto left outer join
      Grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto left outer join
      EgisAdmin.dbo.Usuario us on us.cd_usuario = r.cd_usuario left outer join
      Pedido_compra pc with (nolock, index(PK_Pedido_Compra)) on (ri.cd_pedido_compra = pc.cd_pedido_compra)left outer join 
      pedido_compra_item pci with (nolock, index(PK_Pedido_Compra_Item)) on pci.cd_pedido_compra = pc.cd_pedido_compra

  where (IsNUll(p.nm_fantasia_produto,'') like @nm_fantasia_produto + '%') and
        ( (@ic_tipo_requisicao = 'T') or
          ( (@ic_tipo_requisicao = 'A') and 
            (IsNull(ri.cd_pedido_compra,0) = 0) and
	    r.cd_status_requisicao = 1 and 
            r.cd_tipo_requisicao is not null and
            r.ic_liberado_proc_compra = 'S'
	  ) or
          ( (@ic_tipo_requisicao = 'C') and 
             exists (select top 1 IsNull(x.cd_cotacao,0) from Cotacao_item x
  	     where x.cd_requisicao_compra = r.cd_requisicao_compra ) and 
            (IsNull(ri.cd_pedido_compra,0) = 0) and
	    r.cd_status_requisicao = 1 and 
            r.cd_tipo_requisicao is not null and
            r.ic_liberado_proc_compra = 'S'
	  ) or
          ( (@ic_tipo_requisicao = 'P') and 
            (IsNull(ri.cd_pedido_compra,0) <> 0) and
            r.cd_tipo_requisicao is not null
	  )
	)
        
  order by 
    r.dt_emissao_req_compra desc,
    p.nm_fantasia_produto
  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Saldo do Estoque do Produto por Máscara
-------------------------------------------------------------------------------
  begin

   declare @Mascara_Limpa varchar(30)

    set @Mascara_Limpa = Replace(@nm_fantasia_produto,'.','')
    set @Mascara_Limpa = Replace(@Mascara_Limpa,'-','')

    print(@Mascara_Limpa)


    select 
       ri.cd_produto,
       p.cd_mascara_produto,
       p.nm_produto, 
       gp.cd_mascara_grupo_produto,
       ri.nm_prod_requisicao_compra,
       ri.ds_item_requisicao_compra,
       ri.cd_requisicao_compra,
       r.dt_emissao_req_compra,
       ri.dt_item_nec_req_compra as dt_necessidade_req_compra,
       cast(r.dt_necessidade_req_compra as integer) - cast(GetDate() as integer) as 'Dias',
       ri.cd_item_requisicao_compra,
       ri.qt_item_requisicao_compra,
       us.nm_fantasia_usuario,
       dp.nm_departamento,
       ri.cd_item_ped_imp,
       ri.cd_pedido_importacao,
       pci.cd_item_pedido_compra,
       pc.cd_pedido_compra


    from 
      Requisicao_Compra r inner join
      Requisicao_Compra_Item ri with (nolock, index(PK_Requisicao_Compra_Item)) on r.cd_requisicao_compra=ri.cd_requisicao_compra left outer join
      Departamento dp with (nolock, index(PK_Departamento)) on dp.cd_departamento = r.cd_departamento left outer join
      Produto p with (nolock, index(PK_Produto)) on p.cd_produto = ri.cd_produto left outer join
      Grupo_produto gp with (nolock, index(PK_Grupo_Produto)) on gp.cd_grupo_produto = p.cd_grupo_produto left outer join
      EgisAdmin.dbo.Usuario us on us.cd_usuario = r.cd_usuario  left outer join
      Pedido_compra pc with (nolock, index(PK_Pedido_Compra)) on (ri.cd_pedido_compra = pc.cd_pedido_compra)left outer join 
      pedido_compra_item pci with (nolock, index(PK_Pedido_Compra_Item)) on pci.cd_pedido_compra = pc.cd_pedido_compra

    where (IsNull(p.cd_mascara_produto,'') like @Mascara_Limpa + '%') and
          ( (@ic_tipo_requisicao = 'T') or
          ( (@ic_tipo_requisicao = 'A') and 
             (IsNull(ri.cd_pedido_compra,0) = 0) and
	      r.cd_status_requisicao = 1 and 
              r.cd_tipo_requisicao is not null and
              r.ic_liberado_proc_compra = 'S'
  	  ) or
            ( (@ic_tipo_requisicao = 'C') and 
               exists (select top 1 IsNull(x.cd_cotacao,0) from Cotacao_item x
    	     where x.cd_requisicao_compra = r.cd_requisicao_compra ) and 
              (IsNull(ri.cd_pedido_compra,0) = 0) and
  	    r.cd_status_requisicao = 1 and 
              r.cd_tipo_requisicao is not null and
              r.ic_liberado_proc_compra = 'S'
  	  ) or
           ( (@ic_tipo_requisicao = 'P') and 
              (IsNull(ri.cd_pedido_compra,0) <> 0) and
              r.cd_tipo_requisicao is not null
	    )
	)

  order by 
    r.dt_emissao_req_compra desc,
    p.nm_fantasia_produto
end

-------------------------------------------------------------------------------
else if @ic_parametro = 3    -- Consulta Produto por Nome Fantasia
-------------------------------------------------------------------------------
  begin
    select 
       ri.cd_produto,
       ri.cd_pedido_venda,
       p.cd_mascara_produto,
       p.nm_produto,
       gp.cd_mascara_grupo_produto,
       ri.nm_prod_requisicao_compra,
       ri.ds_item_requisicao_compra,
       ri.cd_requisicao_compra,
       r.dt_emissao_req_compra,
       ri.dt_item_nec_req_compra as dt_necessidade_req_compra,
       cast(r.dt_necessidade_req_compra as integer) - cast(GetDate() as integer) as 'Dias',
       ri.cd_item_requisicao_compra,
       ri.qt_item_requisicao_compra,
       us.nm_fantasia_usuario,
       dp.nm_departamento,
       ri.cd_item_ped_imp,
       ri.cd_pedido_importacao,
       pci.cd_item_pedido_compra,
       pc.cd_pedido_compra
    from 
      Requisicao_Compra r inner join
      Requisicao_Compra_Item ri with (nolock, index(pk_requisicao_compra_item)) on r.cd_requisicao_compra=ri.cd_requisicao_compra left outer join
      Departamento dp with (nolock, index(pk_departamento)) on dp.cd_departamento = r.cd_departamento left outer join
      Produto p with (nolock, index(pk_produto)) on p.cd_produto = ri.cd_produto left outer join
      Grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto left outer join
      EgisAdmin.dbo.Usuario us on us.cd_usuario = r.cd_usuario left outer join
      Pedido_compra pc with (nolock, index(pk_pedido_compra)) on (ri.cd_pedido_compra = pc.cd_pedido_compra)left outer join 
      pedido_compra_item pci with (nolock, index(pk_pedido_compra_item)) on pci.cd_pedido_compra = pc.cd_pedido_compra

  where (IsNUll(p.nm_produto,'') like @nm_fantasia_produto + '%') and
        ( (@ic_tipo_requisicao = 'T') or
          ( (@ic_tipo_requisicao = 'A') and 
            (IsNull(ri.cd_pedido_compra,0) = 0) and
	    r.cd_status_requisicao = 1 and 
            r.cd_tipo_requisicao is not null and
            r.ic_liberado_proc_compra = 'S'
	  ) or
          ( (@ic_tipo_requisicao = 'C') and 
             exists (select top 1 IsNull(x.cd_cotacao,0) from Cotacao_item x
  	     where x.cd_requisicao_compra = r.cd_requisicao_compra ) and 
            (IsNull(ri.cd_pedido_compra,0) = 0) and
	    r.cd_status_requisicao = 1 and 
            r.cd_tipo_requisicao is not null and
            r.ic_liberado_proc_compra = 'S'
	  ) or
          ( (@ic_tipo_requisicao = 'P') and 
            (IsNull(ri.cd_pedido_compra,0) <> 0) and
            r.cd_tipo_requisicao is not null
	  )
	)
        
  order by 
    r.dt_emissao_req_compra desc,
    p.nm_fantasia_produto
  end
