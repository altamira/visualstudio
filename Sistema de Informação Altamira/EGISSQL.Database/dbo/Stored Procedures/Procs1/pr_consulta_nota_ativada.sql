



CREATE  PROCEDURE pr_consulta_nota_ativada

@dt_inicial     datetime,
@dt_final       datetime,
@ic_tipo_filtro char(1)

AS

set dateformat mdy

select distinct 
--  n.cd_nota_saida		          as 'NotaFiscal',
  case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
            n.cd_identificacao_nota_saida
          else
            n.cd_nota_saida                              
    end                                   as 'NotaFiscal',

  n.dt_nota_saida                         as 'DataNF',
  n.vl_total    		          as 'ValorTotal',
  ofi.cd_mascara_operacao	          as 'CFOP',
  ( select top 1 max(x.dt_ativacao_nota_saida)
    from Nota_Saida_Item x with (nolock) 
    where x.cd_nota_saida = n.cd_nota_saida ) as 'Ativacao',
  ( select top 1 cast(x.nm_motivo_restricao_item as varchar(100))
    from Nota_Saida_Item x with (nolock) 
    where x.cd_nota_saida = n.cd_nota_saida 
    order by cast(nm_motivo_restricao_item as varchar) desc) as 'Motivo', 
  t.nm_tipo_destinatario            as 'TipoDestinatario',
  n.nm_fantasia_destinatario        as 'Cliente',
  p.nm_fantasia_vendedor	    as 'Vendedor'
from
  Nota_Saida n with (nolock)  left outer join
  Operacao_Fiscal ofi  on ofi.cd_operacao_fiscal = n.cd_operacao_fiscal left outer join
  Vendedor p on n.cd_vendedor = p.cd_vendedor left outer join
  Tipo_Destinatario t on IsNull(n.cd_tipo_destinatario, 7) = t.cd_tipo_destinatario inner join
  Nota_Saida_Item nsi on nsi.dt_ativacao_nota_saida is not null and
                         nsi.cd_nota_saida = n.cd_nota_saida 
where
  (IsNull(n.dt_nota_saida,getdate()) between 
    (case @ic_tipo_filtro when 'E' then @dt_inicial else IsNull(n.dt_nota_saida,getdate()) end ) and 
    (case @ic_tipo_filtro when 'E' then @dt_final else IsNull(n.dt_nota_saida,getdate()) end )
  )
  and
  (IsNull(nsi.dt_ativacao_nota_saida, getdate()) between 
    (case @ic_tipo_filtro when 'A' then @dt_inicial else IsNull(nsi.dt_ativacao_nota_saida, getdate()) end ) and 
    (case @ic_tipo_filtro when 'A' then @dt_final else IsNull(nsi.dt_ativacao_nota_saida, getdate()) end )
  )


