
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias Pereira da Silva
--Banco de Dados: EgisSql
--Objetivo: Campos Impressos na NF relativos aos Cálculos de Substrituição Tributária
--Data: 10/11/2004
--Atualizado: 
-------------------------------------------------------------------------------

CREATE PROCEDURE pr_subst_trib_nota_fiscal
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal int

as  

  declare @pc_icms_interno float
  declare @pc_icms_nota float
  declare @pc_subst_trib float
  declare @vl_produto float  

  -- Verifica se a CFOP da NF é de Substituição Tributária
  if ((select op.ic_subst_tributaria
       from Nota_Saida ns, Operacao_Fiscal op
       where ns.cd_operacao_fiscal = op.cd_operacao_fiscal and
             ns.cd_nota_saida = @cd_nota_fiscal) = 'S')
  begin

    -- Carrega o Valor de Produto, Alíquota Interna do Estado e 
    -- % de Subst. Tributária
    select @vl_produto = ns.vl_produto,
           @pc_icms_interno = ep.pc_aliquota_icms_interna,
           @pc_subst_trib = ep.pc_icms_substrib_estado
    from estado_parametro ep, nota_saida ns, estado uf
    where uf.cd_pais = ns.cd_pais and uf.sg_estado = ns.sg_estado_nota_saida and
          ep.cd_pais = uf.cd_pais and ep.cd_estado = uf.cd_estado and
          ns.cd_nota_saida = @cd_nota_fiscal

    -- Carrega a Alíquota da Nota Fiscal
    select top 1 @pc_icms_nota = pc_icms 
    from nota_saida_item 
    where cd_nota_saida = @cd_nota_fiscal
    group by pc_icms 
          
    select
      'Base de Cálculo do ICMS Retido: ' as MSGBCICMSRETIDO,
      'ICMS Operação Própria: ' as MSGICMSPROPRIO,
      'ICMS Retido: ' as MSGICMSRETIDO,
      'Emitido nos Termos dos Artigos 280 e 281 do RICMS.' as MSGDISPLEGAL,
      cast((@vl_produto * (1 + (@pc_subst_trib/100))) as decimal(25,2)) as BCICMSRETIDO,
      cast((@vl_produto * (@pc_icms_nota/100)) as decimal(25,2)) as ICMSPROPRIO,
      -- BC ICMS RETIDO
      cast((((@vl_produto * (1 + (@pc_subst_trib/100))) * 
      -- MULTIPLICADO PELO ICMS INTERNO
      (@pc_icms_interno/100)) -
      -- DEDUZIDO O ICMS PRÓPRIO
      (@vl_produto * (@pc_icms_nota/100))) as decimal(25,2)) as ICMSRETIDO

  end
  else
  begin

    select
      NULL as MSGBCICMSRETIDO,
      NULL as MSGICMSPROPRIO,
      NULL as MSGICMSRETIDO,
      NULL as MSGDISPLEGAL,
      NULL as BCICMSRETIDO,
      NULL as ICMSPROPRIO,
      NULL as ICMSRETIDO  

  end   

