
CREATE  PROCEDURE pr_consulta_lista_preco_cliente
------------------------------------------------------------------------
--pr_consulta_lista_preco_cliente
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                               2004
------------------------------------------------------------------------	             
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		: Consulta 
--Data			: 14.08.2002
--Alteração             : Igor Gama - 26/02/2004 - Ordenação da sp
--                      : 04/01/2005 - ACerto do Cabeçalho - Sérgio Cardoso
-- 21.02.2010 - Complemento com a Tabela de Preço do Cliente - Carlos Fernandes
-------------------------------------------------------------------------------

@nm_fantasia      varchar(40)  = '',
@sg_estado        char(2)      = '',
@ic_tipo_consulta integer      = 0

as

  declare @cd_estado  int
  declare @cd_cliente int 

  select top 1
    @cd_estado = cd_estado 
  from 
    estado with (nolock)  
  where 
    sg_estado = @sg_estado  

  set @cd_cliente = 0

  if @nm_fantasia<>'' 
  begin

    select  top 1
      @cd_cliente = isnull(cd_cliente,0)
    from
      Cliente c with (nolock) 
    where
      c.nm_fantasia_cliente = @nm_fantasia

  end
  

  --Mostra a Consulta-----------------------------------------------------------------------------  

if @ic_tipo_consulta = 1
begin

  Select   
   tp.nm_tabela_preco,
   cp.nm_categoria_produto,
   m.cd_moeda,
   m.nm_moeda,
   cli.cd_cliente,
   cli.nm_fantasia_cliente,
   cli.nm_razao_social_cliente,
   pro.cd_produto,
   pro.nm_fantasia_produto,
   pro.cd_mascara_produto,
   pro.nm_produto,
   um.sg_unidade_medida,

   es.sg_estado,
   dbo.fn_get_ipi_produto(pro.cd_produto) as pc_ipi,
   isnull(cf.pc_importacao,0)             as pc_ii,

--     
--   (Select top 1 pc_importacao from classificacao_fiscal 
--    where cd_classificacao_fiscal = (Select top 1 cd_classificacao_fiscal from Produto_Fiscal where cd_produto = pro.cd_produto)) as pc_II,

  isnull((Select top 1 
    IsNull(pc_icms_classif_fiscal,0)
     --case when IsNull(pc_icms_classif_fiscal,0) > 0 then pc_icms_classif_fiscal else ep.pc_aliquota_icms_estado end
   from 
      Classificacao_fiscal_Estado with (nolock) 

   where 
     cd_estado = @cd_estado and cd_classificacao_fiscal = pf.cd_classificacao_fiscal ),ep.pc_aliquota_icms_estado) as 'ICMS',

   pro.nm_fantasia_produto     as nm_fantasia_prod_cliente,
   pro.nm_produto              as nm_produto_cliente,
   tpc.vl_tabela_preco         as vl_produto_cliente,
   tpc.vl_base_icms_subs_trib  as vl_base_icms_strib
        
   


--     (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = pro.cd_produto)) as 'ICMS'
--select * from produto_cliente
--select * from tabela_preco_categoria_produto

  from 

    Cliente cli                             with (nolock)
    left outer join Tabela_Preco    tp      with (nolock) on tp.cd_tabela_preco         = cli.cd_tabela_preco

    left outer join 
    tabela_preco_categoria_produto tpc      with (nolock) on tpc.cd_tabela_preco        = tp.cd_tabela_preco

    left outer join categoria_produto cp    with (nolock) on cp.cd_categoria_produto    = tpc.cd_categoria_produto

    left outer join Produto pro             with (nolock) on pro.cd_categoria_produto   = cp.cd_categoria_produto 
                                                                                          
--    left outer join Produto pro             with (nolock) on (pro.cd_produto            = pc.cd_produto )
                                                              
                                                               
    left outer join Moeda m                 with (nolock) on (m.cd_moeda                = pro.cd_moeda )
                              
    left outer join Produto_Fiscal pf       with (nolock) on pf.cd_produto              = pro.cd_produto

    --left outer join Cliente cli with (nolock) on (pc.cd_cliente = cli.cd_cliente) 

    left outer join Estado es               with (nolock) on (cli.cd_estado             = es.cd_estado)
    left outer join Estado_Parametro ep     with (nolock) on (ep.cd_estado              = es.cd_estado and ep.cd_pais = es.cd_pais )

    left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
    left outer join Unidade_Medida um       with (nolock) on um.cd_unidade_medida       = pro.cd_unidade_medida
--select * from estado_parametro

   where 
     cli.cd_cliente = case when @cd_cliente = 0 then cli.cd_cliente else @cd_cliente end and
     cli.nm_fantasia_cliente like @nm_fantasia + '%'
     and isnull(pro.cd_produto,0)>0                       

   Order by 
     --cli.cd_cliente,
     cli.nm_fantasia_cliente

end

--Produto por Cliente

if @ic_tipo_consulta = 2
begin

  Select   
   ''                          as nm_tabela_preco,
   ''                          as nm_categoria_produto,
   m.cd_moeda,
   m.nm_moeda,
   cli.nm_fantasia_cliente,
   cli.nm_razao_social_cliente,
   pro.nm_fantasia_produto,
   pro.cd_mascara_produto,
   pro.nm_produto,
   um.sg_unidade_medida,

   es.sg_estado,
   dbo.fn_get_ipi_produto(pro.cd_produto) as pc_ipi,
   isnull(cf.pc_importacao,0)             as pc_ii,

--     
--   (Select top 1 pc_importacao from classificacao_fiscal 
--    where cd_classificacao_fiscal = (Select top 1 cd_classificacao_fiscal from Produto_Fiscal where cd_produto = pro.cd_produto)) as pc_II,

  isnull((Select top 1 
    IsNull(pc_icms_classif_fiscal,0)
     --case when IsNull(pc_icms_classif_fiscal,0) > 0 then pc_icms_classif_fiscal else ep.pc_aliquota_icms_estado end
   from 
      Classificacao_fiscal_Estado with (nolock) 

   where 
     cd_estado = @cd_estado and cd_classificacao_fiscal = pf.cd_classificacao_fiscal ),ep.pc_aliquota_icms_estado) as 'ICMS',

   pc.*,
   0.00 as vl_base_icms_strib


--     (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = pro.cd_produto)) as 'ICMS'
--select * from produto_cliente

  from 

    Cliente cli                             with (nolock)

    left outer join Produto_Cliente pc      with (nolock) on (pc.cd_cliente             = cli.cd_cliente)

    left outer join Produto pro             with (nolock) on (pro.cd_produto            = pc.cd_produto )
                                                              
                                                               
    left outer join Moeda m                 with (nolock) on (m.cd_moeda                = pro.cd_moeda )
                              
    left outer join Produto_Fiscal pf       with (nolock) on pf.cd_produto              = pro.cd_produto

    --left outer join Cliente cli with (nolock) on (pc.cd_cliente = cli.cd_cliente) 

    left outer join Estado es               with (nolock) on (cli.cd_estado             = es.cd_estado)
    left outer join Estado_Parametro ep     with (nolock) on (ep.cd_estado              = es.cd_estado and ep.cd_pais = es.cd_pais )

    left outer join classificacao_fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
    left outer join Unidade_Medida um       with (nolock) on um.cd_unidade_medida       = pro.cd_unidade_medida

--select * from estado_parametro

   where 
     --cli.cd_cliente = case when @cd_cliente = 0 then cli.cd_cliente else @cd_cliente end and
     cli.nm_fantasia_cliente like @nm_fantasia + '%'
     and isnull(pro.cd_produto,0)>0                       

   Order by 
     --cli.cd_cliente,
     cli.nm_fantasia_cliente


end

