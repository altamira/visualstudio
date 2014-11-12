
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias Pereira da Silva
--Banco de Dados: EgisSql
--Objetivo: Campos Impressos na NF relativos aos Cálculos de Dif. de Alíquota 
--          do ICMS
--Data: 13/12/2004
--Atualizado: 
-------------------------------------------------------------------------------

CREATE PROCEDURE pr_dif_aliq_icms_nota_fiscal
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal int

as  

  declare @pc_icms_estado float
  declare @pc_icms_nota float
  declare @pc_subst_trib float
  declare @vl_produto float  

  declare @cd_prefixo_cfop char(1)
  declare @ic_dif_aliquota char(1)

  select @cd_prefixo_cfop = substring(op.cd_mascara_operacao,1,1),
         @ic_dif_aliquota = isnull(c.ic_dif_aliq_icms,'N')
  from Nota_Saida ns 
  inner join Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
  left outer join Cliente c on ns.cd_tipo_destinatario = 1 and ns.cd_cliente = c.cd_cliente
  where ns.cd_nota_saida = @cd_nota_fiscal
  
  -- Verifica se a CFOP da NF é de Outro Estado (Prefixo 6)
  -- e se o Cliente tem Dif. de Alíquota
  if ((@cd_prefixo_cfop = '6') and (@ic_dif_aliquota = 'S'))
  begin

    -- Carrega o Valor de Produto, Alíquota Interna do Estado
    select @vl_produto = ns.vl_produto,
           @pc_icms_estado = ep.pc_aliquota_icms_estado
    from estado_parametro ep, nota_saida ns, egisadmin..empresa em
    where ep.cd_pais = em.cd_pais and ep.cd_estado = em.cd_estado and
          em.cd_empresa = dbo.fn_empresa() and
          ns.cd_nota_saida = @cd_nota_fiscal

    -- Carrega a Alíquota da Nota Fiscal
    select top 1 @pc_icms_nota = pc_icms 
    from nota_saida_item 
    where cd_nota_saida = @cd_nota_fiscal
    group by pc_icms 

    select
      'Base de Cálculo do ICMS: ' as MSGBCICMS,
      'ICMS Operação Própria: ' as MSGICMSPROPRIO,
      'ICMS Retido p/ Dif. Aliquota: ' as MSGICMSRETIDO,
      cast(cast(@vl_produto as decimal(25,2)) as varchar) + ' x '+
      cast(cast(@pc_icms_estado as decimal(25,2)) as varchar) + ' = '+
      cast(cast((@vl_produto * (@pc_icms_estado/100)) as decimal(25,2)) as varchar) as BCICMS,

      cast(cast(@vl_produto as decimal(25,2)) as varchar) + ' x '+
      cast(cast(@pc_icms_nota as decimal(25,2)) as varchar) + ' = '+
      cast(cast((@vl_produto * (@pc_icms_nota/100)) as decimal(25,2)) as varchar) as BCICMSPROPRIO,

      cast(cast(@vl_produto * (@pc_icms_estado/100) as decimal(25,2)) - 
           cast(@vl_produto * (@pc_icms_nota/100) as decimal(25,2)) as varchar) as ICMSDIFALIQ

  end
  else
  begin

    select
      NULL as MSGBCICMS,
      NULL as MSGICMSPROPRIO,
      NULL as MSGICMSRETIDO,
      NULL as BCICMS,
      NULL as BCICMSPROPRIO,
      NULL as ICMSDIFALIQ

  end   

