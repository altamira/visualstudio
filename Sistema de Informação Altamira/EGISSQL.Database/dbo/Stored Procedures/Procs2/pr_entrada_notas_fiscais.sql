

create procedure pr_entrada_notas_fiscais

@dt_inicial datetime,
@dt_final   datetime

as

  select
    distinct
    n.cd_nota_entrada 		as 'Nota',
    nr.cd_rem		 	as 'REM',
    n.dt_receb_nota_entrada	as 'Recebimento',
    n.dt_nota_entrada           as 'Emissao',
    v.nm_fantasia 	        as 'Fornecedor',
    v.nm_razao_social,
    v.cd_cnpj,
    rtrim(ltrim(v.cd_ddd))+' '+v.cd_telefone         as 'Telefone',

    case when isnull(o.ic_servico_operacao,'N') = 'S' then
      n.vl_servico_nota_entrada - (isnull(n.vl_irrf_nota_entrada,0) + isnull(n.vl_inss_nota_entrada,0))
    else
      n.vl_prod_nota_entrada - (isnull(n.vl_irrf_nota_entrada,0) + isnull(n.vl_inss_nota_entrada,0))
    end				as 'TotalProduto',
    n.vl_ipi_nota_entrada	as 'IPI',
    n.vl_icms_nota_entrada	as 'ICMS',
    n.vl_total_nota_entrada - (isnull(n.vl_irrf_nota_entrada,0) + isnull(n.vl_inss_nota_entrada,0))
 				as 'TotalNota',
    n.ic_scp			as 'ContasPagar',
    'SemVlrComercial' =
    case when o.ic_comercial_operacao = 'N' then '!' else null end,
    -- ELIAS 25/09/2003
    'Servico' = case when isnull(o.ic_servico_operacao,'N') = 'S' then '*' else null end,
    'S'				as 'Forn',
    ( select top 1 IsNull(p.ic_aprov_pedido_compra,'N')
      from Pedido_Compra p inner join
           Nota_Entrada_Item nei on p.cd_pedido_compra = nei.cd_pedido_compra
      where
        nei.cd_nota_entrada      = n.cd_nota_entrada and
        nei.cd_fornecedor        = n.cd_fornecedor and
        nei.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal ) as ic_aprov_pedido_compra,

    o.cd_mascara_operacao,
    o.nm_operacao_fiscal,
    ( select count(*)
      from 
       nota_entrada_parcela nep
      where
        nep.cd_nota_entrada      = n.cd_nota_entrada and 
        nep.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal and
        nep.cd_operacao_fiscal   = n.cd_operacao_fiscal   and
        nep.cd_fornecedor        = n.cd_fornecedor
    )                                      as qt_parcela,

--     cast(0 as int)          as 'Pedido_Compra',
--     cast('' as varchar(50)) as 'Plano_Compra',
--     0.00                    as 'ICMS'

    (select 
       top 1 cd_pedido_compra
     from          
       nota_entrada_item with (nolock) 
     where      
        cd_nota_entrada = n.cd_nota_entrada and 
        cd_fornecedor   = n.cd_fornecedor   and
        cd_operacao_fiscal = n.cd_operacao_fiscal and
        cd_serie_nota_fiscal = n.cd_serie_nota_fiscal ) as 'Pedido_Compra',

    (select
       top 1 plc.nm_plano_compra
     from
       nota_entrada_item nei,
       pedido_compra pc,
       plano_compra plc 
     where
       nei.cd_nota_entrada      = n.cd_nota_entrada      and 
       nei.cd_operacao_fiscal   = n.cd_operacao_fiscal   and
       nei.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal and
       nei.cd_fornecedor        = n.cd_fornecedor        and
       pc.cd_pedido_compra      = nei.cd_pedido_compra   and
       pc.cd_plano_compra       = plc.cd_plano_compra) as 'Plano_Compra'

--select * from nota_entrada_parcela
--select * from nota_entrada   
--select * from vw_destinatario

  from
    Nota_Entrada          n  with (nolock) 
    left outer join 
    Nota_Entrada_Registro nr with (nolock) on n.cd_nota_entrada      = nr.cd_nota_entrada and
                                              n.cd_fornecedor        = nr.cd_fornecedor   and
                                              n.cd_operacao_fiscal   = nr.cd_operacao_fiscal and
                                              n.cd_serie_nota_fiscal = nr.cd_serie_nota_fiscal
    left outer join 
    vw_Destinatario       v  with (nolock) on n.cd_fornecedor = v.cd_destinatario and isnull(n.cd_tipo_destinatario,2) = v.cd_tipo_destinatario 
    left outer join 
    Operacao_fiscal       o  with (nolock) on n.cd_operacao_fiscal = o.cd_operacao_fiscal
    

--sp_help vw_Destinatario
--select * from nota_entrada

  where
    n.dt_receb_nota_entrada between @dt_inicial and @dt_final

  order by
    v.nm_fantasia,
    n.cd_nota_entrada,
    nr.cd_rem 

/*
  
-- tabela temporária que guarda informações da Nota
select 
  distinct
    n.fan_cli,
    n.nf,
    e.rem,
    n.vlripi,
    n.vlrtotal,
    n.vlrinss,
    n.vlriss,
    e.codno,
    n.natop01,
    f.comercial
  into
    #cadenf_temp
  from 
    sap.dbo.cadenf n, 
    sap.dbo.cadrine e,
    sap.dbo.ftoper f 
  where 
    n.nf = e.nf and 
    n.fan_cli = e.fan_for and 
    e.CODNO = f.CODIGO and
    e.dtentr between @dt_inicial and @dt_final

-- tabela temporária que guarda informações do fornecedor
SELECT 
  c.FAN_CLI,
  c.NF,
  c.REM,
  b.RCREDNF
INTO
  #InfFornec_temp
FROM 
  SAP.DBO.CADECNF c, 
  SAP.DBO.FTPLANO B 
WHERE 
  c.DTENTR between @dt_inicial and @dt_final and 
  c.CODCONTA = B.CODCONTA AND 
  (c.SERIE NOT LIKE '%D%' OR c.SERIE IS NULL)

select
  DISTINCT
  a.NF as 'Nota', 
  a.REM as 'REM',
  a.DTENTR as 'Recebimento',
  a.FAN_FOR as 'Fornecedor',
  (a.VLRCONT - a.IPI) as 'TotalProduto',
  (a.IPI) as 'IPI',
  (a.VLRCONT - n.VLRINSS - n.VLRISS) as 'TotalNota',
  (a.ICMS) as 'ICMS',
   a.CODNO,
  (SELECT top 1 i.SCP from SAP.DBO.CADENF i where a.NF = i.NF and a.FAN_FOR = i.FAN_CLI and i.DTREC between @dt_inicial AND @dt_final) as 'ContasPagar',
  case when 'S' in (select f.COMERCIAL from #cadenf_temp f where a.CODNO = f.CODNO and a.REM = f.REM and a.NF = f.NF) then '' else '!' end as 'SemVlrComercial',
  case when a.NATOP is null and ('S' in (select f.COMERCIAL from SAP.DBO.FTOPER f, SAP.DBO.CADENF i where i.CODNO01 = f.CODIGO and a.NF = i.NF and a.FAN_FOR = i.FAN_CLI and i.DTREC between @dt_inicial AND @dt_final)) then '*' else '' end as 'Servico',
  case when exists(SELECT top 1 * FROM SAP.DBO.CADECNF c, SAP.DBO.FTPLANO B WHERE c.DTENTR = a.DTENTR and c.CODCONTA = B.CODCONTA AND B.RCREDNF = '2810' AND (c.SERIE NOT LIKE '%D%' OR c.SERIE IS NULL) and c.FAN_CLI = a.FAN_FOR and c.NF = a.NF) and ('S' in (select f.COMERCIAL from SAP.DBO.FTOPER f where a.CODNO = f.CODIGO)) then 'S' else 'N' end as 'Forn'  
into
  #entrada_temp
from
  SAP.DBO.CADRINE a
left outer join
  #cadenf_temp n
on
  a.FAN_FOR = n.FAN_CLI and
  a.NF = n.NF
where
  a.DTENTR between @dt_inicial AND @dt_final

select 
  Nota,
  REM,
  Recebimento,
  Fornecedor,
  sum(TotalProduto) as 'TotalProduto',
  sum(IPI) as 'IPI',
  sum(TotalNota) as 'TotalNota',
  sum(ICMS) as 'ICMS',
  CODNO,
  ContasPagar,
  SemVlrComercial,
  Servico,
  Forn
from
  #entrada_temp
group by
  Nota,
  Rem,
  Recebimento,
  Fornecedor,
  CODNO,
  ContasPagar,
  SemVlrComercial,
  Servico,
  Forn
order by
  Fornecedor, 
  REM

*/



