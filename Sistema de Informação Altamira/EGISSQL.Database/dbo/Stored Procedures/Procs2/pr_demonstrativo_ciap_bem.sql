
-------------------------------------------------------------------------------
--pr_demonstrativo_ciap_bem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva	
--                   Carlos Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 04/11/2006
--Alteração        : 15/11/2006 - Facilitando a consulta adicionando os campos
--                   patrimônio e Nome do Bem.   
--                 : 25/11/2006 - Adicionando pesquisa por período - Anderson
--                 : 10.12.2006 - Filtro por Tipo de Cálculo - Carlos Fernandes
--                 : 21.12.2006 - Adicionando filtro pelo local do bem
------------------------------------------------------------------------------
create procedure pr_demonstrativo_ciap_bem
  @cd_livro_ciap     int         = 0,
  @cd_bem            int         = 0,
  @dt_dataini        datetime    = null,
  @dt_datafim        datetime    = null,
  @cd_patrimonio_bem varchar(25) = '',
  @nm_bem            varchar(25) = '',
  @cd_tipo_ciap      int         = 0,
  @cd_local_bem      int         = 0,
  @ic_parametro      int         = 1,
  @cd_ciap           int         = 0
AS

---------------------------------------------------------------------------
-- Visualizando dados do ciap
---------------------------------------------------------------------------
if @ic_parametro = 1
begin

  -- Atualizando numero do livro ciap no ciap se o demonstrativo for oficial
  if @cd_livro_ciap > 0
  begin
    update
      ciap
    set
      cd_livro_ciap = @cd_livro_ciap
    Where 
      dt_entrada_nota_ciap between @dt_dataIni and @dt_dataFim
  end

  select
    c.cd_ciap,
    c.dt_ciap,
    c.cd_bem,
    b.nm_bem,
    b.ds_bem,
    b.cd_patrimonio_bem,
    tb.nm_tipo_bem,
    f.nm_razao_social,
    c.cd_operacao_fiscal,
    c.cd_nota_entrada,
    snf.sg_serie_nota_fiscal,
    c.cd_livro_entrada,
    c.qt_folha_livro_entrada,
    Case
      when isnull(c.cd_nota_entrada,0)=0 then c.cd_nota_entrada_manual else c.cd_nota_entrada
    end as cd_nota_entrada_manual,
    Case
      when isnull(c.cd_serie_nota_fiscal,0)=0 then c.cd_serie_entrada_manual else c.cd_serie_nota_fiscal
    end as cd_serie_entrada_manual,
    c.dt_entrada_nota_ciap,
    c.qt_mes_ciap,
    isnull(c.vl_icms_ciap, 0) as vl_icms_ciap,
    cs.cd_nota_saida,
    cs.dt_nota_saida,
    snfs.sg_serie_nota_fiscal as sg_serie_nota_fiscal_saida,
    cl.nm_razao_social_cliente,
    cs.cd_livro_saida,
    cs.qt_folha_livro_saida,
    c.cd_livro_ciap,
    c.dt_baixa_ciap,
    c.nm_motivo_baixa_ciap,
    bb.nm_tipo_baixa_bem,
    c.vl_saldo_ciap,
    lbc.cd_insc_est_local_bem,
    lbc.nm_local_bem,
    c.qt_ordem_livro_ciap,
    c.dt_calculo_ciap
  from
    ciap c
    left outer join Bem b                  On b.cd_bem = c.cd_bem
    left outer join Tipo_Bem tb            On tb.cd_tipo_bem = b.cd_tipo_bem
    left outer join Fornecedor f           On f.cd_fornecedor = c.cd_fornecedor
    left outer join Serie_Nota_Fiscal snf  On snf.cd_serie_nota_fiscal = c.cd_serie_nota_fiscal
    left outer join Ciap_Saida cs          On cs.cd_ciap = c.cd_ciap
    left outer join Serie_Nota_Fiscal snfs On snfs.cd_serie_nota_fiscal = cs.cd_serie_nota_fiscal
    left outer join Cliente cl             On cl.cd_cliente = cs.cd_cliente
    left outer join Tipo_Baixa_bem bb      on bb.cd_tipo_baixa_bem = c.cd_tipo_baixa_bem
    left outer join Local_Bem_Ciap lbc     on lbc.cd_local_bem = c.cd_local_bem
  where
    isnull(c.cd_bem,0)       = case when isnull(@cd_bem,0)=0       then isnull(c.cd_bem,0)       else @cd_bem       end and
    isnull(c.cd_local_bem,0) = case when isnull(@cd_local_bem,0)=0 then isnull(c.cd_local_bem,0) else @cd_local_bem end and
    isnull(c.cd_tipo_ciap,0) = case when isnull(@cd_tipo_ciap,0)=0 then isnull(c.cd_tipo_ciap,0) else @cd_tipo_ciap end and
    isnull(c.ic_credito_ciap,'S') = 'S' and
    ((isnull(@dt_dataIni,'')='')         or ( c.dt_entrada_nota_ciap between @dt_dataIni and @dt_dataFim )) and
    ((isnull(@cd_patrimonio_bem,'')= '') or ( RTrim(LTrim(b.cd_patrimonio_bem))like RTrim(LTrim(@cd_patrimonio_bem)) +'%' )) and
    ((isnull(@nm_bem,'')= '')            or ( RTrim(LTrim(b.nm_bem))           like RTrim(LTrim(@nm_bem)) +'%' ))
  Order by
    c.dt_entrada_nota_ciap,
    c.cd_ciap
end

---------------------------------------------------------------------------
-- Visualizando demonstrativo do ciap
---------------------------------------------------------------------------
if @ic_parametro = 2
begin
  select 
    cd.cd_ciap,
    cd.cd_parcela,
    cd.qt_mes,
    cd.qt_ano,
    cd.qt_fator,
    cd.vl_icms,
    cast(cast((cd.qt_mes) as varchar)+'/'+'1'+'/'+cast((cd.qt_ano) as varchar) as datetime) as dt_calculo,
    c.dt_calculo_ciap
  into
    #Ciap_Demonstrativo
  from 
    Ciap_Demonstrativo cd
    inner join Ciap c on c.cd_ciap = cd.cd_ciap
  Where
    cd.cd_ciap = @cd_ciap and
    ( c.dt_baixa_ciap is null or ( cd.qt_ano <= year (c.dt_baixa_ciap) and 
                                   cd.qt_mes <= month(c.dt_baixa_ciap) ) )
  Order by
    cd.cd_parcela

  select * from #Ciap_Demonstrativo where dt_calculo < dt_calculo_ciap
    
end

