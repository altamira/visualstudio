
-------------------------------------------------------------------------------  
--sp_helptext pr_preparacao_carga_nota_saida  
-------------------------------------------------------------------------------  
--pr_preparacao_carga_nota_saida  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2008  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--
--Autor(es)        : Douglas de Paula Lopes  
--
--Banco de Dados   : Egissql  
--Objetivo         : Preparação de Remessa de Carga - Carlos Fernandes  
--Data             : 30.09.2008  
--Alteração        : 13.10.2008   
--  
-- 09.11.2008 - Ajuste Gerais conforme Utilização   - Carlos Fernandes  
-- 02.02.2009 - Modificação para unidade do Cliente - Carlos Fernandes
-- 24.02.2009 - Verificação de Nota Cancelada - Carlos Fernandes
-- 20.11.2009 - Ajuste para quando tem muitas notas - Carlos Fernandes
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes
-- 04.11.2010 - Número da Nota Fiscal - Carlos Fernandes
------------------------------------------------------------------------------  
create procedure pr_preparacao_carga_nota_saida  
@cd_carga      int     = 0,
@dt_inicial    datetime,  
@dt_final      datetime,  
@cd_nota_saida integer,  
@tipo_selecao  integer = 1,  
@notas_selecao varchar(8000) = '0',  
@gerado        integer = 1  

as  

--set @notas_selecao = cast(isnull(@notas_selecao,0) as varchar(8000) )
set @notas_selecao = cast(isnull(@cd_carga,0) as varchar(8000) )

--select @notas_selecao
  
select  
    0                          as ic_selecao,  
    n.cd_identificacao_nota_saida,
    i.cd_nota_saida,    
    i.cd_item_nota_saida,  
    t.nm_fantasia,    
    td.nm_tipo_destinatario,    
    n.nm_fantasia_destinatario as nm_fantasia_cliente,  
    n.dt_saida_nota_saida      as dt_saida_nota_saida,  
    n.dt_nota_saida            as dt_nota_saida,  
    n.vl_total,   
    ume.sg_unidade_medida,  
    v.nm_fantasia_vendedor,  
    te.nm_tipo_embalagem,    
    v.nm_vendedor, 
 
    --Quantidade

    i.qt_item_nota_saida 

    /

    case when isnull(p.qt_multiplo_embalagem,0) > 0 and isnull(c.cd_unidade_medida,0)=0
    then isnull(p.qt_multiplo_embalagem,0)
    else 1 end                 as qt_item_nota_saida,   
    
    p.cd_produto,  
    p.cd_mascara_produto,  
    p.nm_produto,  
    p.nm_fantasia_produto,   
    p.qt_multiplo_embalagem,    
    t.nm_transportadora,     
    n.nm_razao_social_nota,     
    IsNull(n.nm_endereco_entrega,'')      + ' - '   
    + IsNull(n.cd_numero_endereco_ent,'') + ' - '   
    + IsNull(n.nm_complemento_end_ent,'') as 'Endereco',      
    n.nm_bairro_entrega,    
    cid.nm_cidade,    
    est.sg_estado,    
    '(' + Isnull(t.cd_ddd,'') + ')' + t.cd_telefone as 'cd_telefone',    
    n.nm_endereco_entrega, n.cd_numero_endereco_ent,    
    n.nm_complemento_end_ent,      
    n.nm_pais_nota_saida,    
    n.sg_estado_entrega,    
    n.nm_cidade_entrega,    
    n.nm_fantasia_destinatario,    
    n.cd_tipo_local_entrega,     
    n.nm_obs_entrega_nota_saida,    
    n.nm_marca_nota_saida,     
    n.nm_numero_emb_nota_saida,     
    isnull(n.qt_volume_nota_saida,0)   as qt_volume_nota_saida,     
    n.nm_especie_nota_saida,     
    isnull(n.qt_peso_liq_nota_saida,0) as qt_peso_liq_nota_saida,     
    n.qt_peso_bruto_nota_saida ,    
    n.vl_frete,    
    n.cd_entregador,    
    e.nm_entregador,  
    ve.nm_veiculo,  
    cr.nm_cliente_regiao,  
    m.nm_motorista,  
    n.ic_sel_nota_saida,  
    0.0                                as qt_total_embalagem,  
    cast(' ' as varchar)               as sg_unidade_medida_embalagem,
    cp.nm_categoria_produto,
    isnull(c.cd_unidade_medida,0)      as cd_unidade_cliente,
    n.cd_ordem_carga   

into  
  #nota_selecao  

from  
  nota_saida_item                   i   with (nolock)   
  inner join nota_saida             n   with (nolock) on (n.cd_nota_saida        = i.cd_nota_saida and  
                                                         isnull(n.ic_sel_nota_saida,'N') = case when @gerado = 1 then  
                                                                                             'N'  
                                                                                           else  
                                                                                             'S'  
                                                                                           end)         
  inner join produto                p   with (nolock) on p.cd_produto            = i.cd_produto  
  left outer join unidade_medida    um  with (nolock) on um.cd_unidade_medida    = p.cd_unidade_medida  
  left outer join tipo_embalagem    te  with (nolock) on te.cd_tipo_embalagem    = p.cd_tipo_embalagem  
  left outer join unidade_medida    ume with (nolock) on ume.cd_unidade_medida   = i.cd_unidade_medida    
  left outer join vendedor          v   with (nolock) on v.cd_vendedor           = n.cd_vendedor   
  left outer Join transportadora    t   with (nolock) on n.cd_transportadora     = t.cd_transportadora     
  left outer join Tipo_Destinatario td  with (nolock) on n.cd_tipo_destinatario  = td.cd_tipo_destinatario    
  left outer join Cidade            cid with (nolock) on cid.cd_cidade           = t.cd_cidade and cid.cd_estado = t.cd_estado and   
                                                                                                   cid.cd_pais   = t.cd_pais   
  left outer join Estado            est with (nolock) on est.cd_estado           = t.cd_estado and est.cd_pais   = t.cd_pais    
  left outer join Entregador        e   with (nolock) on n.cd_entregador         = e.cd_entregador  
  left outer join veiculo           ve  with (nolock) on ve.cd_veiculo           = n.cd_veiculo   
  left outer join cliente           c   with (nolock) on c.cd_cliente            = n.cd_cliente
  left outer join cliente_regiao    cr  with (nolock) on cr.cd_cliente_regiao    = c.cd_regiao     
  left outer join motorista         m   with (nolock) on m.cd_motorista          = n.cd_motorista     
  left outer join categoria_produto cp  with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto

where  
  n.dt_nota_saida between  @dt_inicial and @dt_final and  

  n.cd_nota_saida in (case when @cd_nota_saida = 0 then   
                        n.cd_nota_saida     
                      else   
                        @cd_nota_saida end)         and

  --Nota Fiscal não pode estar cancelada ou devolvida
  n.cd_status_nota = 5                              and --Nota já Impressa
  i.dt_restricao_item_nota is null                  

  --Ordem de Carga
  --n.cd_ordem_carga = @cd_carga
 
--select * from nota_saida_item
--select * from status_nota
 
order by  
  i.cd_nota_saida,  
  i.cd_item_nota_saida  
  

--select * from #nota_selecao

--select * from Cliente

--Verifica o Tipo de Seleção
  
if @tipo_selecao = 1  
  begin  

    select   
      *   
    from   
      #nota_selecao n   
    where   
      n.cd_item_nota_saida <= (select   
                                 min(cd_item_nota_saida)   
                               from   
                                 nota_saida_item   
                               where   
                                 cd_nota_saida = n.cd_nota_saida)   
    order by
      n.dt_nota_saida desc
   
  end  
else  

  if @tipo_selecao = 2   
    begin  
      declare @sql varchar(8000)   
      set @sql = 'select cd_produto, max(cd_mascara_produto) as cd_mascara_produto, max(nm_fantasia_produto) as nm_fantasia_produto, ' +  
      'max(nm_produto) as nm_produto, max(sg_unidade_medida) as sg_unidade_medida, sum(qt_item_nota_saida) as qt_item_nota_saida, '+  
      'max(nm_tipo_embalagem) as nm_tipo_embalagem, max(qt_multiplo_embalagem)as qt_multiplo_embalagem, '+  
      'sum(qt_item_nota_saida * qt_multiplo_embalagem ) as qt_total_embalagem, '+  
      'max(sg_unidade_medida) as sg_unidade_medida_embalagem,max(nm_categoria_produto) from #nota_selecao where cd_ordem_carga in ('+@notas_selecao+ ') '+
      'group by cd_produto order by max(nm_categoria_produto),max(cd_mascara_produto) '  
      exec (@sql)  
    end  
  else  
    begin  
   

      declare @sql2 varchar(8000)   

      set @sql2 = 'select cd_identificacao_nota_saida, cd_nota_saida, max(qt_peso_liq_nota_saida) as qt_peso_liq_nota_saida , max(qt_peso_bruto_nota_saida) as qt_peso_bruto_nota_saida, ' +  
                  'max(vl_total) as vl_total, max(qt_volume_nota_saida) as qt_volume_nota_saida, max(nm_transportadora) as nm_transportadora, max(vl_frete) as vl_frete, ' +  
                  'max(nm_fantasia_destinatario) as nm_fantasia_destinatario, max(nm_fantasia)as nm_fantasia from #nota_selecao ' + 'where isnull(cd_ordem_carga,0) in ('+@notas_selecao+ ') group by cd_nota_saida, cd_identificacao_nota_saida'  

      --print @sql2

      exec (@sql2)  

    end  
  
drop table #nota_selecao   

--select * from nota_saida where cd_nota_saida = 25914

