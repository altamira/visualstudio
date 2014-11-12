
------------------------------------------------------------------------------------------------------------------ 
--GBS - Global Business Solution                2002 
------------------------------------------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)      : Elias Pereira
--                 Carlos Fernandes
--Banco de Dados : EGISSQL 
--Objetivo       : Manutenção das Contabilizações
--Data           : ???
--Atualização: 30/10/2003 - Carregamento da informação de que o registro foi modificado - ELIAS
--             17/11/2003 - Aplicado filtro na tab do cursor para somente operação entrada - ELIAS
--             05/12/2003 - Acréscimo do campo reduzido - ELIAS
--             10/05/2004 - Inclusão de novos parâmetros (@vl_csll_nota_entrada, @vl_cofins_nota_entrada, @vl_pis_nota_entrada,
--                            @vl_inss_nota_entrada, @vl_iss_nota_entrada, @vl_irrf_nota_entrada) - DUELA
--             05/08/2005 - Acerto na Geração da Contabilização que estava duplicando quando o usuário
--                          efetuava o cadastro de mais do que um lançamento padrão com a mesma conta principal - ELIAS
--             18.12.2006 - Acertos Diveros - Carlos Fernandes
--             06.09.2007 - Verificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------  


create procedure pr_manutencao_contabilizacao_entrada
@ic_parametro           int = 0,
@cd_nota_entrada        int = 0,
@cd_fornecedor          int = 0,
@cd_operacao_fiscal     int = 0,
@cd_serie_nota_fiscal   int = 0,
@cd_destinacao_produto  int = 0,
@cd_plano_compra        int = 0,
@cd_tributacao          int = 0,
@cd_lancamento_padrao   int = 0,
@cd_conta_plano         int = 0,
@vl_contabil            decimal(25,2) = 0,
@vl_icms                decimal(25,2) = 0,
@vl_ipi                 decimal(25,2) = 0,
@cd_usuario             int = 0,
@cd_conta_reduzido      int = 0,
@ic_eh_manutencao_mesmo char(1) = 'S',
@vl_csll_nota_entrada   float = 0,
@vl_cofins_nota_entrada float = 0,
@vl_pis_nota_entrada    float = 0,
@vl_inss_nota_entrada   float = 0,
@vl_iss_nota_entrada    float = 0,
@vl_irrf_nota_entrada   float = 0

as

begin

-- Valores DEFAULT
set @cd_conta_reduzido      = isnull(@cd_conta_reduzido,0)
set @ic_eh_manutencao_mesmo = isnull(@ic_eh_manutencao_mesmo,'S')

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- DELEÇÃO DAS CONTABILIZAÇÕES DE UMA NF
-------------------------------------------------------------------------------
begin
  -- Apagando antes as contabilizações existentes
  delete from
    Nota_Entrada_Contabil
  where
    cd_nota_entrada      = @cd_nota_entrada and
    cd_fornecedor        = @cd_fornecedor and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
    cd_operacao_fiscal   = @cd_operacao_fiscal  
end

-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- GERAÇÃO DE CONTABILIZAÇÃO
-------------------------------------------------------------------------------
begin

  declare @Debito       int
  declare @Credito      int
  declare @CodHistorico int
  declare @Tipo         int
  declare @Lancamento   int
  declare @Historico    varchar(200)
  declare @Item         int
  declare @DataContabil datetime

  -- Encontrando o Item
  select
    @Item = cd_it_contab_nota_entrada
  from
    Nota_Entrada_Contabil with (nolock)
  where	
    cd_nota_entrada      = @cd_nota_entrada and
    cd_fornecedor        = @cd_fornecedor and
    cd_operacao_fiscal   = @cd_operacao_fiscal and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal

  if @Item is null 
    set @Item = 0

  select
    @DataContabil        = dt_receb_nota_entrada
  from
    Nota_Entrada
  where
    cd_nota_entrada      = @cd_nota_entrada and
    cd_fornecedor        = @cd_fornecedor and
    cd_operacao_fiscal   = @cd_operacao_fiscal and
    cd_serie_nota_fiscal = @cd_serie_nota_fiscal

  -- Apenas para manter a compatibilidade

  if @cd_conta_reduzido = 0
  select
    @cd_conta_reduzido = isnull(cd_conta_reduzido,0)
  from
    plano_conta
  where
    cd_empresa = dbo.fn_empresa() and
    cd_conta   = @cd_conta_plano
    
  -- Abrindo 

  declare cLanctoPadrao cursor for
  select 
    l.cd_conta_debito,
    l.cd_conta_credito,
    max(l.cd_historico_contabil),
    l.cd_tipo_contabilizacao,
    max(h.nm_historico_contabil),
    -- ELIAS 05/08/2005
    min(l.cd_lancamento_padrao) as cd_lancamento_padrao
  from 
    lancamento_padrao l
    left outer join historico_contabil h on h.cd_historico_contabil = l.cd_historico_contabil    
  where 
    l.cd_conta_plano = (select top 1 cd_conta from plano_conta 
                        where cd_conta_reduzido = @cd_conta_reduzido and
                              cd_empresa = dbo.fn_empresa()) and
    l.ic_tipo_operacao = 'E' 
  group by
    l.cd_conta_debito,
    l.cd_conta_credito,
    l.cd_tipo_contabilizacao
  order by
    l.cd_tipo_contabilizacao

  open cLanctoPadrao

  fetch next from cLanctoPadrao into @Debito, @Credito, @CodHistorico, @Tipo, @Historico, @Lancamento

  while @@fetch_status = 0
  begin  
    set @Item = @Item + 1

    -----------------------------
    -- NOTA_FISCAL
    -----------------------------
    if @Tipo = 1 
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_contab_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_contabil,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)
    end

    -----------------------------
    -- ICMS
    -----------------------------
    if @Tipo = 2 
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_icms_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_icms,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- IPI
    -----------------------------
    if @Tipo = 3
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_ipi_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_ipi,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- IRRF
    -----------------------------
    if @Tipo = 16
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_irrf_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_irrf_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- INSS
    -----------------------------
    if @Tipo = 17
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_inss_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_inss_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- ISS
    -----------------------------
    if @Tipo = 19
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_iss_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_iss_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- COFINS
    -----------------------------
    if @Tipo = 20
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_cofins_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_cofins_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end
    
    -----------------------------
    -- PIS
    -----------------------------
    if @Tipo = 21
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_pis_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_pis_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    -----------------------------
    -- CSLL
    -----------------------------
    if @Tipo = 22
    begin
      -- Incluindo o Registro no Nota_Entrada_Contabil
      insert into Nota_Entrada_Contabil (
        cd_nota_entrada,
        cd_fornecedor,
        cd_operacao_fiscal,
        cd_serie_nota_fiscal,
        cd_it_contab_nota_entrada,
        dt_contab_nota_entrada,
        cd_lancamento_padrao,
        cd_conta_debito,
        cd_conta_credito,
        cd_historico_contabil,
        nm_historico_nota_entrada,
        cd_usuario,
        dt_usuario,
        vl_csll_nota_entrada,
        cd_plano_compra,
        cd_destinacao_produto,
        cd_tributacao,
        ic_manutencao_contabil)
      values (
        @cd_nota_entrada,
        @cd_fornecedor,
        @cd_operacao_fiscal,
        @cd_serie_nota_fiscal,
        @Item,
        @DataContabil,
        @Lancamento,
        @Debito,
        @Credito,
        @CodHistorico,
        @Historico,
        @cd_usuario,
        getdate(),
        @vl_csll_nota_entrada,
        @cd_plano_compra,
        @cd_destinacao_produto,
        @cd_tributacao,
        @ic_eh_manutencao_mesmo)      
    end

    fetch next from cLanctoPadrao into @Debito, @Credito, @CodHistorico, @Tipo, @Historico, @Lancamento
  end

  close cLanctoPadrao
  deallocate cLanctoPadrao
end

end  

