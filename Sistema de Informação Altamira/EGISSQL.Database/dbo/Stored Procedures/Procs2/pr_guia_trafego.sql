
------------------------------------------------------------------------------
--GBS - Global Business Solution
--Stored Procedure : Microsoft SQL Server 2003
--Autor(es) : Daniel C. Neto.
--Data      : 16/07/2003
--Objetivo  : Mostrar notas fiscais para realizar guias de tráfego.
--Atualizado: 17/12/2003 - Atualização referente a inclusão do campo 'cd_guia_trafego_nota_said' - DANIEL DUELA
--            03/02/2004 - Mudado order by - Daniel C. Neto.
------------------------------------------------------------------------------        

CREATE   procedure pr_guia_trafego

@ic_parametro int,
@dt_inicial datetime,
@dt_final   datetime,
@cd_nota_Saida int

as 

-----------------------------------------------------------
if @ic_parametro = 1 -- Dados da consulta.
-----------------------------------------------------------
begin

  select 
    distinct
    0 as Selecionado,
    td.nm_tipo_destinatario,
    n.nm_fantasia_destinatario as nm_fantasia_cliente,	 --Cliente
    isnull(n.dt_saida_nota_saida,getdate()) as 'dt_saida_nota_saida', --Saida
    isnull(n.dt_nota_saida,getdate()) as 'dt_nota_saida', --Emissao
    n.vl_total, 		 --Valor
    v.nm_fantasia_vendedor,
    v.nm_vendedor,		 --Vendedor
    n.cd_nota_saida,		 --Nota
    nsi.cd_item_nota_saida,
    IsNull(n.cd_guia_trafego_nota_said,0) as cd_guia_trafego_nota_said,
    n.nm_razao_social_nota as 'nm_razao_social_nota', 
    case 
      when (n.cd_tipo_local_entrega = 1) then IsNull(n.nm_endereco_nota_saida,'') + ' - ' + IsNull(n.cd_numero_end_nota_saida,'') 
      else IsNull(n.nm_endereco_entrega,'') + ' - ' + IsNull(n.cd_numero_endereco_ent,'') + ' - ' + IsNull(n.nm_complemento_end_ent,'') 
    end as 'Endereco',
    case 
      when (n.cd_tipo_local_entrega = 1)  then n.nm_bairro_nota_saida 
      else n.nm_bairro_entrega 
    end as 'nm_bairro',
    case 
      when (n.cd_tipo_local_entrega = 1) then n.nm_cidade_nota_saida 
      else n.nm_cidade_entrega 
    end as 'nm_cidade',
    case 
      when n.cd_tipo_local_entrega = 1 then n.sg_estado_nota_saida 
      else n.sg_estado_entrega 
    end as 'sg_estado',
    case 
      when n.cd_tipo_local_entrega = 1 then '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
      else '( ' + IsNull(cd_ddd_nota_saida,'') + ' ) ' + n.cd_telefone_nota_saida
    end as 'cd_telefone',
    n.nm_endereco_entrega, n.cd_numero_endereco_ent,
    n.nm_complemento_end_ent,
    n.nm_bairro_entrega,
    n.nm_pais_nota_saida,
    n.sg_estado_entrega,
    n.nm_cidade_entrega,
    n.cd_tipo_local_entrega, 
    n.nm_obs_entrega_nota_saida,
    n.nm_marca_nota_saida, 
    n.nm_numero_emb_nota_saida, 
    n.qt_volume_nota_saida, 
    n.nm_especie_nota_saida, 
    n.qt_peso_liq_nota_saida, 
    n.qt_peso_bruto_nota_saida ,
    n.vl_frete,
    n.cd_entregador,
    e.nm_entregador
  from
    nota_saida n 
  left join Tipo_Destinatario td on 
    n.cd_tipo_destinatario = td.cd_tipo_destinatario 
  left outer join Operacao_fiscal op on 
    n.cd_operacao_fiscal = op.cd_operacao_fiscal 
  left Outer Join Grupo_Operacao_Fiscal gop on 
    op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal 
  left outer Join vendedor v on 
    n.cd_vendedor = v.cd_vendedor 
  left outer join Entregador e on 
    n.cd_entregador = e.cd_entregador 
  left outer join Nota_Saida_Item nsi on 
    nsi.cd_nota_saida = n.cd_nota_saida 
  left outer join Grupo_Produto gp on 
    gp.cd_grupo_produto = nsi.cd_grupo_produto     
  where  
    ( ( (n.dt_nota_saida between @dt_inicial and @dt_final) and  
        (@cd_nota_saida = 0) ) or  
     (n.cd_nota_saida = @cd_nota_Saida) ) and  
  
-- Comentado ao pedido da Amonex  
--      op.ic_comercial_operacao = 'S' and  
      gop.cd_tipo_operacao_fiscal = 2 and  
      IsNull(gp.ic_guia_trafego_grupo,'N') = 'S'  
  order by  
    n.cd_nota_saida desc  
end


  
  

