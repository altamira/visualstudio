
------------------------------------------------------------------------------- 
CREATE  PROCEDURE pr_impressao_pedido_venda
-------------------------------------------------------------------------------
--pr_impressao_pedido_venda
-------------------------------------------------------------------------------
--POLIMOLD INDUSTRIAL S/A                                                  2006
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Fabio Cesar Magalhães
--Banco de Dados          : EGISSQL
--Objetivo                : Retorna o(s) pedido(s) a ser(em) impresso(s)
--Data                    : 27.07.2006
-----------------------------------------------------------------------------------------------------------------------
 @ic_parametro int=0, -- 0=Código do Pedido direto / 1=Intervalo de PV / 2=Intervalo de Data / 3=Todos Pedidos em Aberto
 @cd_pedido_venda_inicial int = 0,
 @cd_pedido_venda_final int = 0,
 @dt_inicial DateTime = '2006/01/01',
 @dt_final   DateTime = '2006/01/01',
 @cd_departamento int = 0,
 @ic_somente_alterado char(1)='N',  --Filtra somente os pedidos alterados
 @ic_somente_liberado char(1)='N', --Realiza uma filtragem adicional somente dos pedidos liberados
 @ic_mostrar_valor_original char(1) = 'S' --Apresentar Valor Original
AS
begin
  
  declare @ic_permissao_item char(1)
  Select top 1 @ic_permissao_item = ic_controle_emissao_ped from Parametro_Comercial
                                               where cd_empresa = dbo.fn_empresa()

  Select distinct 
    cd_pedido_venda    
  into
    #Filtro
  from
    Pedido_Venda pv with (nolock, index(pk_pedido_venda))
  where
    ( @ic_parametro = 0 )
    and pv.cd_pedido_venda = @cd_pedido_venda_inicial
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(pk_pedido_venda))
  where
    ( @ic_parametro = 1 )
    and pv.cd_pedido_venda between @cd_pedido_venda_inicial and @cd_pedido_venda_final
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(IX_Pedido_Venda))
  where
    ( @ic_parametro = 2)
    and ( @ic_permissao_item = 'N' )
    and ( @ic_somente_alterado <> 'S' )
    and ( pv.dt_cancelamento_pedido is null )
    and ( pv.dt_pedido_venda between @dt_inicial and @dt_final )
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(IX_Pedido_Venda_DtAlteracao))
  where
    ( @ic_parametro = 2)
    and ( @ic_permissao_item = 'N' )
    and ( @ic_somente_alterado = 'S' )
    and ( pv.dt_cancelamento_pedido is null )
    and ( pv.dt_alteracao_pedido_venda between @dt_inicial and @dt_final )
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(IX_Pedido_Venda))
  where
    (@ic_parametro = 2)
    and (@ic_permissao_item = 'S')
    and ( @ic_somente_alterado <> 'S' )
    and ( pv.dt_cancelamento_pedido is null )
    and ( dbo.fn_verifica_permissao_item(cd_pedido_venda, @cd_departamento) = 'S' )
    and ( pv.dt_pedido_venda between @dt_inicial and @dt_final )
    and not exists(Select 'x' from Pedido_Venda_Impressao pvi with (nolock, index(PK_Pedido_Venda_Impressao))
                   where pvi.cd_pedido_venda = pv.cd_pedido_venda 
                         and pvi.cd_departamento = @cd_departamento) 
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(IX_Pedido_Venda_DtAlteracao))
  where
    (@ic_parametro = 2)
    and (@ic_permissao_item = 'S')
    and pv.dt_cancelamento_pedido is null
    and ( dbo.fn_verifica_permissao_item(cd_pedido_venda, @cd_departamento) = 'S' )
    and ( pv.dt_alteracao_pedido_venda between @dt_inicial and @dt_final )
    and not exists(Select 'x' from Pedido_Venda_Impressao pvi with (nolock, index(PK_Pedido_Venda_Impressao))
                   where pvi.cd_pedido_venda = pv.cd_pedido_venda 
                         and pvi.cd_departamento = @cd_departamento) 
  UNION
  Select 
    cd_pedido_venda    
  from
    Pedido_Venda pv with (nolock, index(IX_Pedido_Venda_DtCancelamento))
  where
    ( @ic_parametro = 2 )
    and ( @ic_permissao_item = 'S')
    and ( dbo.fn_verifica_permissao_item(cd_pedido_venda, @cd_departamento) = 'S' )
    and ( @ic_somente_alterado <> 'S' )
    and ( pv.dt_cancelamento_pedido between @dt_inicial and @dt_final )
    and exists(Select 'x' from Pedido_Venda_Impressao pvi with (nolock, index(PK_Pedido_Venda_Impressao))
                   where pvi.cd_pedido_venda = pv.cd_pedido_venda 
                         and pvi.cd_departamento = @cd_departamento) 

  UNION
  Select distinct
    pv.cd_pedido_venda    
  from
    Pedido_Venda_Item pvi with (nolock, index(IX_Pedido_Venda_Item_Saldo))
    inner join Pedido_Venda pv with (nolock, index(pk_pedido_venda))
      on pv.cd_pedido_venda = pvi.cd_pedido_venda
  where
    ( @ic_parametro = 3 )
    and ( pvi.qt_saldo_pedido_venda > 0 )
    and ( pvi.dt_cancelamento_item is null )

  
  Select 
    pv.cd_pedido_venda as cd_pedido_venda_sub,
    filtro.cd_pedido_venda
  into
    #Origem
  from 
    #Filtro filtro
    inner join Pedido_Venda pv with (nolock,Index(IX_Pedido_Venda_Origem)) 
      on IsNull(pv.cd_pedido_venda_origem,0) = filtro.cd_pedido_venda
  

  if ( @ic_somente_liberado = 'S' )
    delete from #Filtro
    where not exists(Select 'x' from pedido_venda pv with (nolock,Index(PK_Pedido_venda)) 
                     where pv.cd_pedido_venda = #Filtro.cd_pedido_venda
                           and (pv.dt_credito_pedido_venda is not null))


  Select
    pv.cd_pedido_venda,
    pv.cd_pedido_venda_origem,
    pv.dt_pedido_venda, 
    pv.cd_identificacao_empresa,
    pv.pc_desconto_pedido_venda,
    pv.cd_cliente,
    pai.cd_pais,
    pai.nm_pais,  
    cli.nm_razao_social_cliente,    
    cli.cd_cnpj_cliente, 
    tip.nm_mascara_tipo_pessoa as nm_mascara_CNPJ,
    pv.cd_tipo_entrega_produto, 
    pv.dt_alteracao_pedido_venda,
    pv.nm_alteracao_pedido_venda,
    pv.cd_consulta,
    pv.ic_operacao_triangular,
    pv.nm_contato_op_triang_ped,
    pv.nm_referencia_consulta,
    pv.vl_sedex_pedido_venda, 
    pv.vl_frete_pedido_venda,
    IsNull(pv.ic_fatsmo_pedido, pv.ic_smo_pedido_venda) as ic_smo_pedido_venda,
    IsNull(pv.ic_outro_cliente,'N')  as 'ic_outro_cliente',        --Entrega em outro cliente
    pv.cd_cliente_entrega,
    pv.cd_pdcompra_pedido_venda,
    IsNull(pv.ic_amostra_pedido_venda, 'N')  as ic_amostra_pedido_venda, --Pedido p/ amostra
    IsNull(pv.ic_consignacao_pedido, 'N')  as ic_consignacao_pedido,   --Pedido p/ consignação
    IsNull(pv.ic_subs_trib_pedido_venda,'N') as ic_subs_trib_pedido_venda, --Substituição Tributária
    pv.ic_obs_corpo_nf,           --Flag p/ observações da NF
    pv.ds_obs_fat_pedido,         --Observação da NF
    pv.qt_liquido_pedido_venda, --Peso Líquido
    pv.qt_bruto_pedido_venda,   --Peso Bruto
    IsNull(pv.ic_fechamento_total, 'N') as ic_fechamento_total, 
    pv.ds_observacao_pedido,
    pv.vl_custo_financeiro,
    pv.dt_credito_pedido_venda,
    pv.cd_motivo_liberacao,
    pv.dt_cancelamento_pedido, 
    pv.ic_custo_financeiro, 
    pv.vl_tx_mensal_cust_fin, 
    pv.ds_observacao_pedido as ds_pedido_venda,
    pv.cd_moeda,
    pv.dt_cambio_pedido_venda,
    pv.vl_indice_pedido_venda,
    case 
      when pv.dt_alteracao_pedido_venda is null then ''
      else 'Pedido de Venda Alterado'
    end as nm_alteracao_pv,
    cli.cd_inscestadual, 
    '(' + rtrim(sp.sg_status_pedido) + ')' as nm_status_pedido,  
    getdate() as dt_impressao,   
    --Define o Endereço do cliente quando mercado externo
    case IsNull(ic_end_esp_tipo_mercado,'N')
        when 'S' then
         IsNull('Endereço: ' + cast(cli.ds_cliente_endereco as varchar(1000)),'') 
 else 
         '' 
    end as ds_cliente_endereco,
    case when ((Select count(cd_consulta) from pedido_venda_item with (NOLOCK, Index(PK_Pedido_Venda_Item))
                                 where cd_pedido_venda = pv.cd_pedido_venda) = 1) then
                                cast(pv.cd_consulta as varchar)+'-'+
                               (cast((select top 1 cd_item_consulta from pedido_venda_item with (NOLOCK,Index(PK_Pedido_Venda_Item))
                                      where cd_pedido_venda = pv.cd_pedido_venda) as varchar))
                     else cast(pv.cd_consulta as varchar) 
    end as cd_item_consulta,
    case 
      when charindex('-', cli.cd_cep) > 0 then 
        isnull(rtrim(ltrim(cli.nm_endereco_cliente)),'') + isnull(', ' + cast(ltrim(rtrim(cli.cd_numero_endereco)) as varchar(5)), '') + isnull(' - ' + ltrim(rtrim(cli.nm_bairro)), '') + isnull(' - ' + ltrim(rtrim(cid.nm_cidade)), '') + isnull(' - ' + ltrim(rtrim(uf.sg_estado)), '') + isnull(' - cep: ' + cast(ltrim(rtrim(cli.cd_cep)) as varchar(09)), '')
      else isnull(rtrim(ltrim(cli.nm_endereco_cliente)),'') + isnull(', ' + cast(ltrim(rtrim(cli.cd_numero_endereco)) as varchar(5)), '') + isnull(' - ' + ltrim(rtrim(cli.nm_bairro)), '') + isnull(' - ' + ltrim(rtrim(cid.nm_cidade)), '') + isnull(' - ' + 
        ltrim(rtrim(uf.sg_estado)), '') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + 
        isnull(cast(ltrim(rtrim(cli.cd_cep)) as varchar(8)),''),8)), '') 
    end as nm_endereco_cliente,
    case IsNull(pv.cd_cliente_faturar,0)
      when 0 then ''
      else (Select top 1 cli_aux.nm_fantasia_cliente from cliente cli_aux with (NOLOCK, index(pk_cliente)) 
            where cli_aux.cd_cliente = pv.cd_cliente_faturar)
    end as nm_cliente_op_triangular,
    tra.nm_transportadora, 
    con.nm_contato_cliente,
    cli.cd_ddd,
    cli.cd_telefone,
    cli.cd_fax, 
    cp.nm_condicao_pagamento,
    tf.nm_tipo_frete,
    tle.nm_tipo_local_entrega,
    IsNull(tle.ic_end_tipo_local_entrega,'N') as ic_end_tipo_local_entrega,     
    case IsNull(pv.cd_cliente_entrega,0)
      when 0 then ''
      else (Select top 1 cli_aux.nm_fantasia_cliente from cliente cli_aux with (NOLOCK, index(pk_cliente)) 
            where cli_aux.cd_cliente = pv.cd_cliente_entrega) 
    end as nm_cliente_entrega,
    case IsNull(pv.cd_tipo_endereco,0)
        when '' then ''
        else (Select top 1
  	            case 
                  when charindex('-', clie.cd_cep_cliente) > 0 then 
                    isnull(rtrim(ltrim(clie.nm_endereco_cliente)),'') + isnull(', ' + cast(ltrim(rtrim(clie.cd_numero_endereco)) as varchar(5)), '') + 
                          isnull(' - ' + ltrim(rtrim(clie.nm_bairro_cliente)), '') + isnull(' - ' + ltrim(rtrim(cid.nm_cidade)), '') + isnull(' - ' + 
                          ltrim(rtrim(uf.sg_estado)), '') + isnull(' - cep: ' + cast(ltrim(rtrim(clie.cd_cep_cliente)) as varchar(09)), '')
                  else isnull(rtrim(ltrim(clie.nm_endereco_cliente)),'') + isnull(', ' + cast(ltrim(rtrim(clie.cd_numero_endereco)) as varchar(5)), '') + 
                             isnull(' - ' + ltrim(rtrim(clie.nm_bairro_cliente)), '') + isnull(' - ' + ltrim(rtrim(cid.nm_cidade)), '') + isnull(' - ' + 
                             ltrim(rtrim(uf.sg_estado)), '') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + 
                             isnull(cast(ltrim(rtrim(clie.cd_cep_cliente)) as varchar(8)),''),8)), '') 
                end 
              From cliente_endereco clie with (NOLOCK) 
                inner join estado uf 
                  on clie.cd_estado = uf.cd_estado
          	    inner join cidade cid 
                  on cid.cd_cidade = clie.cd_cidade
              Where 
                clie.cd_cliente = pv.cd_cliente 
                and clie.cd_tipo_endereco = pv.cd_tipo_endereco) 
    end as nm_endereco_cliente_entrega, --Endereço de entrega do Pedido para outro endereço do cliente
    tpf.nm_tipo_pagamento_frete,
    dp.nm_destinacao_produto,
    ven.nm_vendedor,
    cli.nm_fantasia_cliente,
    (select top 1 nm_usuario from egisadmin.dbo.usuario with (NOLOCK) where cd_usuario = pv.cd_usuario_atendente) as nm_usuario_atendente,  
    veni.nm_vendedor as nm_vendedor_interno,
    case when 
       exists(select 'x' from cliente_endereco ce with (NOLOCK) where ce.cd_cliente = cli.cd_cliente and 
              ce.cd_tipo_endereco = 3 )--tipo de cobrança
    then
      (select top 1
  		  case 
  		    when charindex('-', cle.cd_cep_cliente) > 0 then 
  		      isnull(rtrim(ltrim(cle.nm_endereco_cliente)),'') + isnull(', ' + cast(rtrim(ltrim(cle.cd_numero_endereco)) as varchar(5)),'') + isnull(', ' + rtrim(ltrim(cle.nm_bairro_cliente)),'') + isnull(', ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - '
 + rtrim(ltrim(est.sg_estado)),'') + isnull(' - cep: ' + cast(ltrim(rtrim(cle.cd_cep_cliente)) as varchar(09)), '') +  isnull(' - fone: ' + rtrim(ltrim(cle.cd_ddd_cliente)),'') + isnull(' ' + rtrim(ltrim(cle.cd_telefone_cliente)),'')
  		    else 
            isnull(rtrim(ltrim(cle.nm_endereco_cliente)),'') + isnull(', ' + cast(rtrim(ltrim(cle.cd_numero_endereco)) as varchar(5)),'') + isnull(', ' + rtrim(ltrim(cle.nm_bairro_cliente)),'') + isnull(', ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - 
' + rtrim(ltrim(est.sg_estado)),'') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + cast(rtrim(ltrim(cle.cd_cep_cliente)) as varchar(08)),8)), '') + isnull(' - fone: ' + rtrim(ltrim(cle.cd_ddd_cliente)),'') + isnull(' ' + rtrim
(ltrim(cle.cd_telefone_cliente)),'')
  		  end
       from
         cliente_endereco cle with (NOLOCK) left outer join pais pai on cle.cd_pais = pai.cd_pais
         left outer join estado est on est.cd_pais = cle.cd_pais and est.cd_estado = cle.cd_estado
         left outer join cidade cid on cid.cd_pais = cle.cd_pais and cid.cd_estado = cle.cd_estado and cid.cd_cidade = cle.cd_cidade
       where
         cle.cd_cliente = pv.cd_cliente and cle.cd_tipo_endereco = 3 )--tipo cobrança
    else
  	  case 
  	    when charindex('-', cli.cd_cep) > 0 then 
  	      isnull(rtrim(ltrim(cli.nm_endereco_cliente)) ,'') + isnull(', ' + cast(rtrim(ltrim(cli.cd_numero_endereco)) as varchar(5)),'') + isnull(' - ' + rtrim(ltrim(cli.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - ' + rtrim(ltrim(uf.sg_estado)),'') + isnull(' - cep: ' + cast(ltrim(rtrim(cli.cd_cep)) as varchar(09)), '')
  	    else 
          isnull(rtrim(ltrim(cli.nm_endereco_cliente)) ,'') + isnull(', ' + cast(rtrim(ltrim(cli.cd_numero_endereco)) as varchar(5)),'') + isnull(' - ' + rtrim(ltrim(cli.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - ' + rtrim(ltrim(uf.sg_estado)),'') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + cast(rtrim(ltrim(cli.cd_cep)) as varchar(08)),8)), '') 
  	  end
    end as nm_endereco_cobranca,
    case when
       exists(select 'x' from cliente_endereco with (NOLOCK) where cd_cliente = cli.cd_cliente and cd_tipo_endereco = 4 )--tipo de entrega
    then
      (select top 1
         case 
  		     when charindex('-', cle.cd_cep_cliente) > 0 then 
  		       isnull(rtrim(ltrim(cle.nm_endereco_cliente)),'') + isnull(', ' + rtrim(ltrim(cast(cle.cd_numero_endereco as varchar(5)))),'') + isnull(' - ' + rtrim(ltrim(cle.nm_bairro_cliente)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' -
 ' + rtrim(ltrim(est.sg_estado)),'') + isnull(' - cep: ' + cast(ltrim(rtrim(cle.cd_cep_cliente)) as varchar(09)), '') + isnull(' - fone: ' + (isnull(rtrim(ltrim(cle.cd_ddd_cliente)),'') + isnull(' ' + rtrim(ltrim(cle.cd_telefone_cliente)),'')),'')
  		     else 
             isnull(rtrim(ltrim(cle.nm_endereco_cliente)),'') + isnull(', ' + rtrim(ltrim(cast(cle.cd_numero_endereco as varchar(5)))),'') + isnull(' - ' + rtrim(ltrim(cle.nm_bairro_cliente)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull('
 - ' + rtrim(ltrim(est.sg_estado)),'') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + cast(rtrim(ltrim(cle.cd_cep_cliente)) as varchar(08)),8)), '') + isnull(' - fone: ' +(isnull(rtrim(ltrim(cle.cd_ddd_cliente)),'') + isnull('
 ' + rtrim(ltrim(cle.cd_telefone_cliente)),'')),'')
  		   end
       from
         cliente_endereco cle with (NOLOCK) left outer join pais pai on cle.cd_pais = pai.cd_pais
         left outer join estado est on est.cd_pais = cle.cd_pais and est.cd_estado = cle.cd_estado
         left outer join cidade cid on cid.cd_pais = cle.cd_pais and cid.cd_estado = cle.cd_estado and cid.cd_cidade = cle.cd_cidade
       where
         cle.cd_cliente = pv.cd_cliente and cle.cd_tipo_endereco = 4 ) --tipo entrega
    else
  		case 
   		  when charindex('-', cli.cd_cep) > 0 then 
  		    isnull(rtrim(ltrim(cli.nm_endereco_cliente)),'') + isnull(', ' + rtrim(ltrim(cast(cli.cd_numero_endereco as varchar(5)))),'') + 
                      isnull(' - ' + rtrim(ltrim(cli.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - ' + 
                      rtrim(ltrim(uf.sg_estado)),'') + isnull(' - cep: ' + cast(ltrim(rtrim(cli.cd_cep)) as varchar(09)), '')
  		 else 
  		    isnull(rtrim(ltrim(cli.nm_endereco_cliente)),'') + isnull(', ' + rtrim(ltrim(cast(cli.cd_numero_endereco as varchar(5)))),'') + 
                      isnull(' - ' + rtrim(ltrim(cli.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(cid.nm_cidade)),'') + isnull(' - ' + 
                      rtrim(ltrim(uf.sg_estado)),'') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + cast(rtrim(ltrim(cli.cd_cep)) as varchar(08)),8)), '')
  		end
    end as nm_endereco_entrega,
    case pv.cd_transportadora when 0 then null else pv.cd_transportadora end cd_transportadora,
    (select top 1
  		case 
   		  when charindex('-', tr.cd_cep) > 0 then 
  		    isnull(rtrim(ltrim(tr.nm_endereco)),'') + isnull(', ' + rtrim(ltrim(cast(tr.cd_numero_endereco as varchar(5)))),'') + isnull(' - ' + rtrim(ltrim(tr.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(ci.nm_cidade)),'') + isnull(' - ' + rtrim(ltrim(es.sg_estado)),'') + isnull(' - cep: ' + cast(ltrim(rtrim(tr.cd_cep)) as varchar(09)), '')
  		 else 
  		    isnull(rtrim(ltrim(tr.nm_endereco)),'') + isnull(', ' + rtrim(ltrim(cast(tr.cd_numero_endereco as varchar(5)))),'') + 
                      isnull(' - ' + rtrim(ltrim(tr.nm_bairro)),'') + isnull(' - ' + rtrim(ltrim(ci.nm_cidade)),'') + isnull(' - ' + 
                      rtrim(ltrim(es.sg_estado)),'') + isnull(' - cep: ' + dbo.fn_formata_mascara('99999-999',right('00000000' + 
                      cast(rtrim(ltrim(tr.cd_cep)) as varchar(08)),8)), '')
  		end
     from
       transportadora tr with (nolock, index(pk_transportadora)) 
       inner join pais pa 
         on pa.cd_pais = tr.cd_pais 
       inner join estado es 
         on es.cd_pais = tr.cd_pais and tr.cd_estado = es.cd_estado 
       inner join cidade ci 
         on ci.cd_pais = tr.cd_pais and ci.cd_estado = tr.cd_estado and ci.cd_cidade = tr.cd_cidade
     where
       tr.cd_transportadora = pv.cd_transportadora) as nm_endereco_transportadora,
    tra.cd_ddd as cd_ddd_transportadora,
    tra.cd_telefone as cd_telefone_transportadora,
    tra.nm_email_transportadora,
    cet.ds_especificacao_tecnica, 
    case @ic_mostrar_valor_original
      when 'S' then (pv.vl_total_pedido_venda / IsNull(vl_indice_pedido_venda, 1))
      else ( pv.vl_total_pedido_venda )
    end vl_total_pedido_venda,
    case @ic_mostrar_valor_original
      when 'S' then (pv.vl_total_ipi / IsNull(vl_indice_pedido_venda, 1))
      else pv.vl_total_ipi
    end vl_total_ipi,
    case @ic_mostrar_valor_original
      when 'S' then (pv.vl_total_pedido_ipi / IsNull(vl_indice_pedido_venda, 1))
      else pv.vl_total_pedido_ipi
  end vl_total_pedido_ipi,
    tp.sg_tipo_pedido,
    case IsNull(pv.cd_usuario_credito_pedido,0)
      when 0 then ''
      else (Select top 1 nm_fantasia_usuario from egisadmin.dbo.usuario with (NOLOCK) where cd_usuario = pv.cd_usuario_credito_pedido) 
    end as nm_usuario_credito,
    m.sg_moeda,  
    l.sg_loja, 
    IsNull(l.cd_loja,0) as cd_loja,
    case IsNull(pv.cd_usuario_alteracao,0)
      when 0 then ''
      else (Select top 1 nm_fantasia_usuario from Egisadmin.dbo.usuario with (NOLOCK)
            where cd_usuario = pv.cd_usuario_alteracao) 
    end as nm_usuario_alteracao,
    pvo.cd_pedido_venda_sub
  from
    #Filtro filtro
    inner join pedido_venda pv with (nolock, index(pk_pedido_venda)) 
      on pv.cd_pedido_venda = filtro.cd_pedido_venda
    inner join cliente cli with (nolock, index(pk_cliente)) 
      on pv.cd_cliente = cli.cd_cliente
    left outer join tipo_pessoa tip with (nolock, index(pk_tipo_pessoa))
      on tip.cd_tipo_pessoa = cli.cd_tipo_pessoa
    inner join Tipo_Mercado tm with (nolock, index(pk_tipo_mercado))
      on cli.cd_tipo_mercado = tm.cd_tipo_mercado
    left outer join #Origem pvo
      on pvo.cd_pedido_venda  = filtro.cd_pedido_venda
    left outer join vendedor ven with (nolock, index(pk_vendedor)) 
      on ven.cd_vendedor = pv.cd_vendedor 
    left outer join vendedor veni with (nolock, index(pk_vendedor)) 
      on veni.cd_vendedor  = pv.cd_vendedor_interno
    left outer join destinacao_produto dp with (nolock, index(pk_destinacao_produto))
      on pv.cd_destinacao_produto = dp.cd_destinacao_produto 
    left outer join tipo_pagamento_frete tpf with (nolock, index(pk_tipo_pagamento_frete))
      on pv.cd_tipo_pagamento_frete = tpf.cd_tipo_pagamento_frete 
    left outer join tipo_frete tf with (nolock, index(pk_tipo_frete))
      on pv.cd_tipo_frete = tf.cd_tipo_frete 
    left outer join Condicao_pagamento cp with (nolock, index(pk_Condicao_Pagamento))
      on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
    left outer join Cliente_contato con with (nolock, index(PK_Cliente_Contato))
      on pv.cd_contato = con.cd_contato and 
         pv.cd_cliente = con.cd_cliente 
    left outer join Transportadora tra with (nolock, index(pk_Transportadora))
      on pv.cd_transportadora = tra.cd_transportadora 
    left outer join Status_Pedido sp with (nolock, index(pk_status_pedido))
      on pv.cd_status_pedido = sp.cd_status_pedido
    left outer join Cidade cid with (nolock, index(pk_cidade)) 
      on cli.cd_pais   = cid.cd_pais and 
         cli.cd_estado = cid.cd_estado and 
         cli.cd_cidade = cid.cd_cidade 
    left outer join Estado uf with (nolock, index(pk_Estado))
      on cli.cd_pais = uf.cd_pais and 
         cli.cd_estado = uf.cd_estado 
    left outer join Pais pai with (index(pk_pais))
      on cli.cd_pais = pai.cd_pais 
    left outer join Cliente_especificacao_tecnica cet with (NOLOCK, index(PK_Cliente_Especificacao_Tecnica))
      on cli.cd_cliente = cet.cd_cliente 
    left outer join Tipo_pedido tp with (nolock, index(pk_Tipo_pedido))
      on pv.cd_tipo_pedido = tp.cd_tipo_pedido 
    left outer join Tipo_Local_Entrega tle with (index(pk_tipo_local_entrega))
      on pv.cd_tipo_local_entrega = tle.cd_tipo_local_entrega
    left outer join Moeda m with (index(pk_moeda))
      on pv.cd_moeda = m.cd_moeda
    left outer join  Loja l with (index(pk_loja))
      on l.cd_loja = pv.cd_loja
order by
  pv.dt_pedido_venda,
  pv.dt_alteracao_pedido_venda,
  pv.cd_pedido_venda
end

