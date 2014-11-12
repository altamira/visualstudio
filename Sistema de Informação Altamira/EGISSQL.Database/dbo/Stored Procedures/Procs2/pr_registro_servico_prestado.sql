
CREATE PROCEDURE pr_registro_servico_prestado

@ic_parametro int,
@dt_inicial datetime,
@dt_final   datetime,
@qt_pagina  int,
@cd_empresa int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista o Registros de Notas Fiscais.
-------------------------------------------------------------------------------
  begin


    -- Trazer: Notas de Serviço não canceladas.
    select 
      s.cd_iss_grupo_servico,
      n.cd_nota_saida,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      n.dt_nota_saida,
      o.cd_operacao_fiscal,
      n.nm_razao_social_nota,
      ' NÃO INFORMADO'              		as 'Servico',
      case when (sum(isnull(nsi.vl_servico,0))=0) then 
        n.vl_servico
      else
        sum(isnull(nsi.vl_servico * isnull(nsi.qt_item_nota_saida,1),0)) +
            isnull(n.vl_frete,0)
      end								as 'VlrTotal',
      nsi.pc_iss_servico,
      SUM(isnull(nsi.vl_iss_servico,0))						as 'ISS'
    into #Nota_Saida_Temp1
    from
      Servico s 
      left outer join Nota_Saida_Item nsi on s.cd_servico = nsi.cd_servico 
      inner join Nota_Saida n on n.cd_nota_saida = nsi.cd_nota_saida and 
                            n.dt_nota_saida between @dt_inicial and @dt_final and 
                            n.cd_status_nota <> 7 
      left outer join Operacao_Fiscal o on o.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
                                           o.ic_servico_operacao = 'S'
    where
      IsNull(s.cd_iss_grupo_servico,0) <> 0 and
      IsNull(s.ic_livro_iss_servico,'N') = 'S'
    group by
      s.cd_iss_grupo_servico,
      nsi.cd_nota_saida,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      o.cd_operacao_fiscal,
      o.cd_mascara_operacao,    
      o.nm_operacao_fiscal,
      n.cd_nota_saida,
      n.dt_nota_saida,
      n.nm_razao_social_nota,
      s.sg_servico, 
      nsi.pc_iss_servico,
      n.vl_servico,
      n.vl_frete
    order by
      s.sg_servico,
      n.cd_nota_saida


    select
      identity(int, 1,1) as 'Codigo',
      cd_iss_grupo_servico,
      cast('NFF' as varchar(25))        	as 'Especie',
      'UN'					as 'Serie',
      d.nm_razao_social,
      dbo.fn_formata_mascara(tp.nm_mascara_tipo_pessoa, d.cd_cnpj) as cd_cnpj,
      n.cd_nota_saida            		as 'Numero',
      0			as 'Item',
      m.nm_mes                                  as 'Data',
      day(n.dt_nota_saida)			as 'Dia',
      ns.sg_estado_nota_saida			as 'UF',
      n.VlrTotal as 'VlrContabil',
      cast(null as varchar(50)) as 'CodContabil',
--      cast((replace(c.cd_mascara_conta, '.', '')+'0') as varchar(20))  as 'CodContabil',
      o.cd_mascara_operacao			as 'CFOP',
      n.pc_iss_servico                      as 'AliqISS',
      isnull(n.ISS,0)                       as 'ISS', 
      o.nm_obs_livro_operacao			as 'Observacoes',
      case when ns.cd_status_nota = 7 then 'C' else
           case when o.cd_mascara_operacao = '0.00' then 'S' else
                case when o.ic_destaca_vlr_livro_op_f <> 'S' then 'N' else
                     'V' end
                end
	           end					as 'Tipo',
      ns.vl_iss_retido
    into
      #Nota_Saida_Temp2
    from
      #Nota_Saida_Temp1 n
      left outer join Nota_Saida ns on ns.cd_nota_saida = n.cd_nota_saida
      left outer join Mes m on m.cd_mes = month(n.dt_nota_saida)
      left outer join vw_Destinatario d on d.cd_destinatario = n.cd_cliente and
                                      d.cd_tipo_destinatario = n.cd_tipo_destinatario
      left outer join Tipo_Pessoa tp on tp.cd_tipo_pessoa = d.cd_tipo_pessoa 
      left outer join Operacao_Fiscal o on o.cd_operacao_fiscal = n.cd_operacao_fiscal 
    order by
      cd_iss_grupo_servico,
      m.nm_mes,
      day(n.dt_nota_saida),
      n.cd_nota_saida

-- seleção do livro              
select
  Codigo,
  s.cd_iss_grupo_servico,
  Especie,
  Serie,
  case 
    when (vl_iss_retido > 0) then nm_razao_social
    else ''
  end as nm_razao_social,
  cd_cnpj as cnpj,
  cast(Numero as varchar(50)) as Numero,
  Numero as NumeroInicial,
  Numero as NumeroFinal,
  Data,
  Dia,
  UF,
  VlrContabil,
  CodContabil,
  CFOP,
  AliqISS,
  ISS,
  vl_iss_retido as ISSRetido,
  Observacoes,
  cast(null as float) as 'VlMateriais',
  cast(null as float) as 'VlSubEmpreitadas'
from
  (Select Distinct cd_iss_grupo_servico from Servico where IsNull(ic_livro_iss_servico,'N') = 'S') s 
  left outer join #Nota_Saida_Temp2 n on s.cd_iss_grupo_servico = n.cd_iss_grupo_servico
Where
  IsNull(s.cd_iss_grupo_servico,0) <> 0 
order by
  s.cd_iss_grupo_servico,
  Numero


--select
--  sum(VlrContabil) 
--from
--  #Livro_Registro_Saida

end

-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- atualização no número da página do livro
-------------------------------------------------------------------------------
  begin
    
    begin tran

    update
      EgisAdmin.dbo.Empresa
    set
      qt_pagreg_saida_empresa = @qt_pagina
    where
      cd_empresa = @cd_empresa

    if @@ERROR = 0
      commit tran
    else
      rollback tran

  end

else  
  return
    

