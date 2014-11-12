
-----------------------------------------------------------------------------------
--pr_consulta_preco_fornecedor
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2005                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Paulo Santos         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta de Preços por Fornecedor
--Data             : 21.01.2005
--                 : 27.04.2007 - Acertos Gerais - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_consulta_preco_fornecedor

@ic_tipo       char(1), 
@cd_fornecedor int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from pedido_compra_item
-----------------------------------------------------------------------------------
--produto
-----------------------------------------------------------------------------------

if @ic_tipo = 'P'
  begin

    select
      pc.cd_fornecedor,
      max(pc.dt_pedido_compra)           as UltimaCompra,
      pci.cd_produto,
      max(pci.vl_item_unitario_ped_comp) as UltimoPreco
    into
      #Produto
    from
      Pedido_Compra pc                  with(nolock)
      inner join Pedido_Compra_Item pci with (nolock)   on pci.cd_pedido_compra = pc.cd_pedido_compra
    where
      isnull(pci.cd_produto,0)>0 and  
      pci.dt_item_canc_ped_compra is null
    group by
      pc.cd_fornecedor,
      pci.cd_produto

    --select * from #Produto
   
    --select * from fornecedor_produto

    select
      frn.nm_fantasia_fornecedor          as Fornecedor,
      pro.cd_mascara_produto              as Codigo,
      pro.nm_fantasia_produto             as Fantasia,  
      pro.nm_produto                      as Decricao,
      und.sg_unidade_medida               as Unidade,
      isnull(moe.sg_moeda,'R$')           as Moeda,
      case when isnull(fpp.vl_produto_moeda,0)>0
      then
        fpp.vl_produto_moeda    
      else
        p.UltimoPreco end                  as Preco,

      case when fpp.dt_produto_moeda is not null
      then 
        fpp.dt_produto_moeda     
      else
        p.UltimaCompra end            as Data,

      fpp.nm_obs_produto_moeda            as Observacao
    from
      Fornecedor_Produto fp              
      left outer join fornecedor frn               on fp.cd_fornecedor      = frn.cd_fornecedor
      left outer join produto pro                  on fp.cd_produto         = pro.cd_produto
      left outer join fornecedor_produto_preco fpp on fpp.cd_fornecedor     = fp.cd_fornecedor and
                                                      fpp.cd_produto        = fp.cd_produto
      left outer join moeda moe                    on fpp.cd_moeda          = moe.cd_moeda
      left outer join unidade_medida und           on pro.cd_unidade_medida = und.cd_unidade_medida  
      left outer join #Produto p                   on p.cd_fornecedor       = fp.cd_fornecedor and
                                                      p.cd_produto          = fp.cd_produto 
      where
      fp.cd_fornecedor = case when @cd_fornecedor = 0 then fp.cd_fornecedor else @cd_fornecedor end
      and frn.nm_fantasia_fornecedor is not null 
      and isnull(p.cd_fornecedor,0)>0 
      and isnull(p.cd_produto,0)>0
    order by
     frn.nm_fantasia_fornecedor,
     pro.nm_fantasia_produto,
     p.UltimaCompra desc

  end

-----------------------------------------------------------------------------------
--Serviço
-----------------------------------------------------------------------------------

if @ic_tipo = 'S'

  begin

    select
      pc.cd_fornecedor,
      Max(pc.dt_pedido_compra)           as UltimaCompra,
      pci.cd_servico,
      max(pci.vl_item_unitario_ped_comp) as UltimoPreco
   into
      #Servico
   from
      Pedido_Compra pc                  with(nolock)
      inner join Pedido_Compra_Item pci with (nolock)   on pci.cd_pedido_compra = pc.cd_pedido_compra
   where
      isnull(pci.cd_servico,0)>0 and  
      pci.dt_item_canc_ped_compra is null
   group by
      pc.cd_fornecedor,
      pci.cd_servico

    --Select * from servico

    select
		  frn.nm_fantasia_fornecedor      as Fornecedor,
		  cast(srv.cd_servico as varchar) as Codigo,
		  srv.nm_servico                  as Fantasia,  
		  cast(srv.ds_servico as varchar) as Decricao,
                  um.sg_unidade_medida            as Unidade,
	          isnull(moe.sg_moeda,'R$')       as Moeda,

		  case when isnull(fsp.vl_servico_moeda,0)>0
                  then 
                    fsp.vl_servico_moeda
                  else
                    s.UltimoPreco end             as Preco,

                  case when fsp.dt_servico_moeda is null
                  then
                    fsp.dt_servico_moeda
                  else
                    s.UltimaCompra
                  end                             as Data,

		  fsp.nm_obs_servico_moeda        as Observacao

	  from
              Fornecedor_Servico fs
                left outer join fornecedor_servico_preco fsp on fsp.cd_fornecedor = fs.cd_fornecedor and
                                                                fsp.cd_servico    = fs.cd_servico
		left outer join fornecedor frn               on fs.cd_fornecedor = frn.cd_fornecedor
		left outer join servico srv                  on fs.cd_servico = srv.cd_servico
		left outer join moeda moe          on fsp.cd_moeda = moe.cd_moeda
                left outer join unidade_medida um  on um.cd_unidade_medida = srv.cd_unidade_medida
                left outer join #Servico s         on s.cd_fornecedor = fs.cd_fornecedor and
                                                      s.cd_servico    = fs.cd_servico
          where 
            fs.cd_fornecedor = case when @cd_fornecedor = 0 then fs.cd_fornecedor else @cd_fornecedor end
            and frn.nm_fantasia_fornecedor is not null 
            and isnull(s.cd_fornecedor,0)>0
            and isnull(s.cd_servico,0)>0

          order by
            frn.nm_fantasia_fornecedor,
            srv.nm_servico,
            s.UltimaCompra desc


 end

--select * from fornecedor_servico_preco

