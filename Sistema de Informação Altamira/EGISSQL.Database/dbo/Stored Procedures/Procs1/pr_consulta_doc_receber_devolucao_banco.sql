
create procedure pr_consulta_doc_receber_devolucao_banco
@dt_inicial datetime,
@dt_final   datetime

as

  select
--     ns.cd_nota_saida             				as 'NotaSaida',
    max(case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida
    end)                                                        as 'NotaSaida',

     max(nsi.dt_restricao_item_nota)   				as 'DataDev',
     max(cast(nsi.nm_motivo_restricao_item as varchar(4000))) 	as 'Motivo',
     max(p.nm_portador)				                as 'Portador',
     min(d.cd_identificacao)				        as 'Documento',
     max(d.dt_emissao_documento)			        as 'Emissao',
     max(d.dt_vencimento_documento)				as 'Vencimento',
     max(d.dt_envio_banco_documento)				as 'Envio',
     cast(sum(d.vl_documento_receber) as decimal(15,2))		as 'Valor',
     cast(sum(d.vl_saldo_documento) as decimal(15,2))           as 'Saldo',
     max(c.nm_fantasia_cliente)			                as 'Cliente',
     min(d.cd_banco_documento_recebe)				as 'NumeroBancario' ,
     cast(max(nd.vl_devolvido)as decimal(15,2)) 		as 'ValorDevolvido' 
  from
     Nota_Saida ns, 
     Nota_Saida_Item nsi, 
     Documento_Receber d, 
     Portador p, 
     Cliente c,
     (select 
      nsd.cd_nota_saida,
      sum((nsd.qt_devolucao_item_nota * nsd.vl_unitario_item_nota) +
                      ((nsd.qt_devolucao_item_nota * nsd.vl_unitario_item_nota) * nsd.pc_ipi / 100)) as vl_devolvido
      from Nota_Saida_Item nsd, nota_saida nfd
      where nsd.cd_nota_saida = nfd.cd_nota_saida     and
            nfd.cd_status_nota in (3,4,7)             and 
            nsd.dt_restricao_item_nota between @dt_inicial and @dt_final
      group by nsd.cd_nota_saida) nd
  where
     ns.cd_nota_saida   = nsi.cd_nota_saida  and
     ns.cd_status_nota in (3,4,7)             and 
     nsi.dt_restricao_item_nota between @dt_inicial and @dt_final and
     ns.cd_nota_saida      = d.cd_nota_saida and
     ns.cd_nota_saida = nd.cd_nota_saida and
     d.dt_envio_banco_documento is not null  and
     d.cd_portador = p.cd_portador           and
     d.cd_cliente  = c.cd_cliente	     and
     isnull(d.cd_banco_documento_recebe,'') <> ''
  group by
    ns.cd_identificacao_nota_saida
  order by
    ns.cd_identificacao_nota_saida
     

