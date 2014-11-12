
--sp_helptext pr_ordem_recebimento

CREATE PROCEDURE pr_ordem_recebimento
-------------------------------------------------------------------
--pr_ordem_recebimento
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2007
-------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Fernandes
--Banco de Dados	: EgisSQL
--Objetivo		: Realizar consulta para Ordem de Recebimento
--Data		        : 21.07.2007
--                      : 

--Atualização           : 
-------------------------------------------------------------------------------------------------
@ic_parametro           as int,
@dt_inicial             as DateTime,
@dt_final               as DateTime,
@cd_nota_entrada        as Int = 0,
@cd_fornecedor          as int = 0

as

--select * from nota_entrada

begin

   Select 
    l.*, 
    ne.cd_nota_entrada, 
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ol.nm_origem_laudo,
    vw.nm_fantasia,
    vw.nm_razao_social,
    vw.nm_tipo_destinatario,
    t.nm_tecnico, 
    p.nm_produto,
    p.ds_produto, 
    p.cd_mascara_produto,
    p.nm_fantasia_produto, 
    um.nm_unidade_medida, 
    cast(null as varchar) as nm_razao_social,
    cast(null as varchar) as cd_cnpj, 
    cast(null as integer) as cd_nota_saida,   
    cast(null as integer) as cd_item_nota_saida,
    cast(null as integer) as cd_nota_saida_item_lote, 
    cast(null as varchar) as nm_status_nota, 
    isnull(po.nm_pais,op.nm_pais) as nm_origem_produto,
    pp.nm_procedencia_produto 
  From 
     Nota_Entrada ne 
      left outer join Laudo l                on l.cd_nota_entrada  = ne.cd_nota_entrada and 
                                                l.cd_fornecedor    = ne.cd_fornecedor 
      left outer join Origem_laudo ol        on l.cd_origem_laudo  = ol.cd_origem_laudo 
      left outer join vw_destinatario vw     on vw.cd_destinatario      = ne.cd_fornecedor and
                                                vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
      left outer join Tecnico t              on (l.cd_tecnico = t.cd_tecnico) 
      left outer join Produto p              on (l.cd_produto = p.cd_produto) 
      left outer join Produto_Fiscal pf      on (l.cd_produto = pf.cd_produto) 
      LEFT OUTER JOIN Procedencia_Produto pp on (pf.cd_procedencia_produto = pp.cd_procedencia_produto) 
      LEFT OUTER JOIN unidade_medida um      on (l.cd_unidade_medida = um.cd_unidade_medida) 
      left outer join Pais op                on (op.cd_pais = p.cd_origem_produto) 
      left outer join Pais po                on po.cd_pais = l.cd_origem_produto 
   where 
    ne.dt_receb_nota_entrada between @dt_inicial  and @dt_final and
    ne.cd_nota_entrada = @cd_nota_entrada 

  order by ne.dt_receb_nota_entrada desc
  
  
end

