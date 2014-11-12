
CREATE PROCEDURE pr_nota_saida_servico
@ic_parametro       int,
@dt_inicial         datetime,
@dt_final           datetime,
@cd_operacao_fiscal int,
@cd_nota_saida      int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- lista as notas de serviço do período
-------------------------------------------------------------------------------
  begin

    select 
      cast( o.cd_operacao_fiscal as varchar(20) ) + ' - ' + 
      cast( o.cd_mascara_operacao as varchar(20) ) + '- ' + o.nm_operacao_fiscal as 'CFOP',
--      n.cd_nota_saida							as 'NF',

      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida
      end                                                               as 'NF',

      n.dt_nota_saida							as 'Emissao',
      n.nm_razao_social_nota						as 'Cliente',
      isnull(s.sg_servico,' NÃO INFORMADO')              		as 'Servico',
      case when (sum(isnull(nsi.vl_servico,0))=0) then 
        n.vl_servico
      else
        sum(isnull(nsi.vl_servico * isnull(nsi.qt_item_nota_saida,1),0)) +
            isnull(n.vl_frete,0)
      end								as 'VlrTotal',
      nsi.pc_iss_servico          					as 'Perc',
      isnull(n.vl_iss,0)						as 'ISS'

    from
      Nota_Saida_Item nsi
    inner join
      Nota_Saida n
    on
      n.cd_nota_saida = nsi.cd_nota_saida 
    left outer join Operacao_Fiscal o on
      o.cd_operacao_fiscal = nsi.cd_operacao_fiscal
    left outer join Servico s on
      s.cd_servico = nsi.cd_servico
    where
      ((nsi.cd_operacao_fiscal = @cd_operacao_fiscal) or (@cd_operacao_fiscal = 0)) and
      n.dt_nota_saida between @dt_inicial and @dt_final and
      n.cd_status_nota <> 7 and  
      o.ic_servico_operacao = 'S'
    group by
      n.cd_nota_saida,
      n.cd_identificacao_nota_saida,
      o.cd_operacao_fiscal,
      o.cd_mascara_operacao,    
      o.nm_operacao_fiscal,
      n.cd_nota_saida,
      n.dt_nota_saida,
      n.nm_razao_social_nota,
      s.sg_servico, 
      nsi.pc_iss_servico,
      n.vl_servico,
      n.vl_frete,
      n.vl_iss      
    order by
      s.sg_servico,
      n.cd_nota_saida

  end

----------------------------------------------------------------------------
else if @ic_parametro = 2  -- lista os itens da nota escolhida
----------------------------------------------------------------------------
begin

  select
    --n.cd_nota_saida,
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida
    end                            as cd_nota_saida,

    n.cd_item_nota_saida,
    n.cd_servico, 
    s.nm_servico,
    s.sg_servico,
    n.ds_servico, 
    n.vl_servico, 
    n.qt_item_nota_saida, 
    n.pc_ipi, 
    n.vl_ipi, 
    n.vl_irrf_nota_saida, 
    n.pc_irrf_serv_empresa,
    n.vl_iss_servico, 
    n.pc_iss_servico
  from Nota_Saida_Item n    with (nolock) 
  inner join Nota_Saida  ns with (nolock) on ns.cd_nota_saida = n.cd_nota_saida
  left outer join Servico s               on s.cd_servico     = n.cd_servico
  where
    n.cd_nota_saida = @cd_nota_saida

end

else
  return

