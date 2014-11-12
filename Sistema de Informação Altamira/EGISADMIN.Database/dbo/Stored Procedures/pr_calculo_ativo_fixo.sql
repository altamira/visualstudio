
CREATE PROCEDURE pr_calculo_ativo_fixo
---------------------------------------------------------------------------
--pr_calculo_ativo_fixo
---------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
---------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EGISSQL 
--Objetivo             : Cálculo do Ativo Fixo
--Data                 : 10.01.2005
--Atualizado           : 20.01.2007
--                     : 23.01.2007 - Acertos Diversos - Carlos Fernandes
---------------------------------------------------------------------------

@ic_parametro          int      = 0,
@dt_inicial            datetime = '',
@dt_final              datetime = '',
@cd_tipo_calculo_ativo int      = 0,
@cd_indice_monetario   int      = 1,
@cd_usuario            int      = 0

---------------------------------------------------------------------------
-- Definição do Parâmetro
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Tipo de Cálculo
---------------------------------------------------------------------------
-- 1 -> Cálculo da Depreciação
-- 2 ->
-- 3 ->
-- 4 -> Todos os Cálculos
---------------------------------------------------------------------------

as

--Conta do Fornecedor

declare @cd_conta_fornecedor int

select
  @cd_conta_fornecedor = isnull(cd_conta,0)
from
  parametro_ativo
where
  cd_empresa = dbo.fn_empresa()

--Cálculo da Depreciação

if @cd_tipo_calculo_ativo = 1 or @cd_tipo_calculo_ativo = 4

begin

  --delete o cálculo no período

  exec pr_zera_movimento_calculo_ativo 1,0,0,@dt_inicial,@dt_final

  --deleta a contabilização no período

  delete from ativo_contabilizacao where dt_ativo_contabilizacao = @dt_final

  --Busca o último código de Cálculo

  declare @cd_calculo_bem int

  select @cd_calculo_bem = isnull(max(cd_calculo_bem),0) from Calculo_Bem

  if @cd_calculo_bem=0
     set @cd_calculo_bem = 1

  --drop table calculo_bem

  --select * from tipo_calculo_ativo
  --select * from bem
  --select * from valor_bem
  --select * from calculo_bem
  --select * from indice_monetario_valor
  --select * from grupo_bem

  select
    identity(int,1,1)                         as cd_calculo_bem,
    b.cd_grupo_bem,
   gb.nm_grupo_bem,
    b.cd_bem,
    b.nm_bem,
    b.cd_patrimonio_bem,
    b.dt_aquisicao_bem,
    B.dt_baixa_bem,
   sb.nm_status_bem,
   vb.vl_fixo_depreciacao_bem,
   vb.pc_producao_bem,
   vb.vl_original_bem,
   vb.vl_baixa_bem,
   vb.pc_depreciacao_bem,
   vb.pc_deprec_acelerada_bem,
   isnull(vb.cd_moeda,1)               as cd_moeda,

   --Valor do Índice de Cálculo = Último Índice Monetário

   (select top 1 isnull(vl_indice_monetario,0)
    from
      indice_monetario_valor
    where
      @cd_indice_monetario = cd_indice_monetario
    order by
      dt_indice_monetario ) as qt_moeda_calculo_bem,
    
    --Cálculo do Valor da Depreciação

    vl_calculo_bem = case when isnull(vb.vl_fixo_depreciacao_bem,0)>0 
                     then
                       vb.vl_fixo_depreciacao_bem
                     else
                        (vb.vl_original_bem*
                        (case when isnull(vb.pc_deprec_acelerada_bem,0)>0 
                            then vb.pc_deprec_acelerada_bem 
                            else case when isnull(vb.pc_depreciacao_bem,0)>0 
                                 then vb.pc_depreciacao_bem else
                                      gb.pc_depreciacao_grupo_bem end
                            end) /100)/12
                     end,

    pc_calculo_bem = ( case when isnull(vb.pc_deprec_acelerada_bem,0)>0 
                            then vb.pc_deprec_acelerada_bem 
                            else case when isnull(vb.pc_depreciacao_bem,0)>0 
                                 then vb.pc_depreciacao_bem else
                                      gb.pc_depreciacao_grupo_bem end
                            end),

    vl_deprec_acumulada_bem  = 0.00,
    vl_residual_bem          = 0.00,
    vl_saldo_depreciacao_bem = 0.00,
    pc_saldo_depreciacao_bem = 0.00,
    pc_depreciado_bem        = 0.00
  
  into
   #bem
  from
    bem b
    inner join status_bem sb on sb.cd_status_bem = b.cd_status_bem
    inner join valor_bem  vb on vb.cd_bem        = b.cd_bem
    inner join grupo_bem  gb on gb.cd_grupo_bem  = b.cd_grupo_bem
  where
    isnull(gb.ic_depreciacao_grupo_bem,'N')='S' and
    isnull(vb.vl_original_bem,0)>0              and
    isnull(sb.ic_calculo_status_bem,'N')='S'    and
    --( vb.dt_fim_depreciacao_bem is null or vb.dt_fim_depreciacao_bem<=@dt_final  ) and
    --vb.dt_fim_depreciacao_bem >= @dt_inicial and
    ( b.dt_baixa_bem is null or b.dt_baixa_bem between @dt_inicial and @dt_final )

order by
  b.dt_aquisicao_bem 

--select * from #bem where cd_bem = 237

--Atualização da Data de Cálculo do Bem

select
  @cd_calculo_bem + b.cd_calculo_bem        as cd_calculo_bem,
  b.cd_bem,
  @dt_final                                 as dt_calculo_bem,
  @cd_tipo_calculo_ativo                    as cd_tipo_calculo_ativo,
  b.cd_moeda,
  b.qt_moeda_calculo_bem,
  b.vl_calculo_bem,
  b.pc_calculo_bem,
  @cd_usuario                               as cd_usuario,
  getdate()                                 as dt_usuario,
  @cd_indice_monetario                      as cd_indice_monetario,
  b.cd_grupo_bem
into
  #Calculo_Bem
from
  #Bem b
order by
  b.dt_aquisicao_bem  


--Insere o cálculo na Tabela oficial

insert into
  calculo_bem
select
  *
from
  #Calculo_Bem

--Mostra o Cálculo do Bem

select
  *
from
  #Calculo_Bem

--Atualização da Tabela Valor Bem
--select * from valor_bem

update
  valor_bem
set
  vl_dep_periodo_bem       = cb.vl_calculo_bem,
  vl_deprec_acumulada_bem  = vl_deprec_acumulada_bem + cb.vl_calculo_bem,
  pc_depreciacao_bem       = cb.pc_calculo_bem,
 -- pc_deprec_acelerada_bem  = cb.pc_deprec_acelerada_bem,
  vl_saldo_depreciacao_bem = vl_original_bem - vl_deprec_acumulada_bem,
  vl_residual_bem          = vl_original_bem - vl_deprec_acumulada_bem
  
from
  Valor_Bem vb
  inner join #Calculo_Bem cb on cb.cd_bem = vb.cd_bem


--Contabilização do Ativo Fixo ( Depreciação )
--select * from grupo_bem_contabilizacao

select
  identity(int,1,1)                     as cd_contabilizacao_ativo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(cb.vl_calculo_bem,0))      as ValorContabilizacao,
  sum(isnull(b.vl_original_bem,0))      as ValorAquisicao,
  sum(isnull(b.vl_baixa_bem,0))         as ValorBaixaBem

into
  #Grupo_Contabilizacao_Depreciacao
from
  Grupo_Bem_Contabilizacao gc
  inner join #Calculo_Bem cb on cb.cd_grupo_bem = gc.cd_grupo_bem
  inner join #Bem b          on b.cd_bem        = cb.cd_bem
where
   gc.cd_tipo_contabilizacao = 25 --Depreciação

group by 
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

select
  identity(int,1,1)                     as cd_contabilizacao_ativo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(cb.vl_calculo_bem,0))      as ValorContabilizacao,
  sum(isnull(b.vl_original_bem,0))      as ValorAquisicao,
  sum(isnull(b.vl_baixa_bem,0))         as ValorBaixaBem

into
  #Grupo_Contabilizacao_Aquisicao
from
  Grupo_Bem_Contabilizacao gc
  inner join #Calculo_Bem cb on cb.cd_grupo_bem = gc.cd_grupo_bem
  inner join #Bem b          on b.cd_bem        = cb.cd_bem
where
   gc.cd_tipo_contabilizacao = 23 and --Aquisição
   b.dt_aquisicao_bem between @dt_inicial and @dt_final 
   
group by 
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

--Baixa do Ativo

select
  identity(int,1,1)                     as cd_contabilizacao_ativo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(cb.vl_calculo_bem,0))      as ValorContabilizacao,
  sum(isnull(b.vl_original_bem,0))      as ValorAquisicao,
  sum(isnull(b.vl_baixa_bem,0))         as ValorBaixaBem

into
  #Grupo_Contabilizacao_Baixa
from
  Grupo_Bem_Contabilizacao gc
  inner join #Calculo_Bem cb on cb.cd_grupo_bem = gc.cd_grupo_bem
  inner join #Bem b          on b.cd_bem        = cb.cd_bem
where
   gc.cd_tipo_contabilizacao = 24 and --Baixa do Ativo
   b.dt_baixa_bem between @dt_inicial and @dt_final    

group by 
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

--select * from #grupo_contabilizacao_baixa

--select * from tipo_contabilizacao

-- select
--  * 
-- from
--   #Grupo_Contabilizacao

declare @cd_contabilizacao_ativo  int
declare @cd_lancamento_padrao     int
declare @cd_conta_debito          int
declare @cd_conta_credito         int
declare @cd_historico_contabil    int
declare @nm_historico_ativo       varchar(40)
declare @vl_ativo_contabilizacao  float      
declare @nm_complemento_ativo     varchar(40)
declare @cd_tipo_contabilizacao   int

set @nm_complemento_ativo = 'Cálculo Dep. Ativo : '+cast(@dt_final as varchar)

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Depreciacao )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
    @vl_ativo_contabilizacao = ValorContabilizacao,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = ''
  from
   #Grupo_Contabilizacao_Depreciacao
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_credito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Histórico Contabil
   
  select 
    @cd_historico_contabil = cd_historico_contabil
  from
    Lancamento_Padrao lp
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao
    
  select
    @nm_historico_ativo = nm_historico_contabil
  from
    Historico_Contabil
  where
    cd_historico_contabil = @cd_historico_contabil

  --Gera o Arquivo Contabilizado

  exec pr_gera_contabilizacao_ativo_fixo
     @dt_final,                 
     @cd_lancamento_padrao,
     @cd_conta_debito,
     @cd_conta_credito,
     @cd_historico_contabil,
     @nm_historico_ativo,
     @vl_ativo_contabilizacao,
     @nm_complemento_ativo,
     @cd_usuario      

   delete from #Grupo_Contabilizacao_Depreciacao where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end

-- select
--   cd_ativo_contabilizacao
--   dt_ativo_contabilizacao
--   cd_lancamento_padrao
--   cd_conta_debito
--   cd_conta_credito
--   cd_historico_contabil
--   nm_historico_ativo
--   vl_ativo_contabilizacao
--   cd_usuario
--   dt_usuario
--   nm_complemento_ativo
-- 



--Aquisição
--Recebimento
set @nm_complemento_ativo = 'Aquisição:'+cast(@dt_inicial as varchar)+' á '+cast(@dt_final as varchar)

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Aquisicao )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
    @vl_ativo_contabilizacao = ValorAquisicao,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = ''

  from
   #Grupo_Contabilizacao_Aquisicao
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_credito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Verifica a Conta Crédito se estiver vazia busca a Conta do Fornecedor Padrão do Parâmetro

  if @cd_conta_credito=0 and @cd_conta_fornecedor>0
     set @cd_conta_credito = @cd_conta_fornecedor

  --Histórico Contabil
   
  select 
    @cd_historico_contabil = cd_historico_contabil
  from
    Lancamento_Padrao lp
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao
    
  select
    @nm_historico_ativo = nm_historico_contabil
  from
    Historico_Contabil
  where
    cd_historico_contabil = @cd_historico_contabil

  --Gera o Arquivo Contabilizado

  exec pr_gera_contabilizacao_ativo_fixo
     @dt_final,                 
     @cd_lancamento_padrao,
     @cd_conta_debito,
     @cd_conta_credito,
     @cd_historico_contabil,
     @nm_historico_ativo,
     @vl_ativo_contabilizacao,
     @nm_complemento_ativo,
     @cd_usuario      

   delete from #Grupo_Contabilizacao_Aquisicao where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end

--Baixa
--Faturamento quando o Egis está Intregado ou seja, é utilizado o módulo SFT

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Baixa )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
    @vl_ativo_contabilizacao = ValorBaixaBem,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = ''

  from
   #Grupo_Contabilizacao_Baixa
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_credito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Histórico Contabil
   
  select 
    @cd_historico_contabil = cd_historico_contabil
  from
    Lancamento_Padrao lp
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao
    
  select
    @nm_historico_ativo = nm_historico_contabil
  from
    Historico_Contabil
  where
    cd_historico_contabil = @cd_historico_contabil

  --Gera o Arquivo Contabilizado

  exec pr_gera_contabilizacao_ativo_fixo
     @dt_final,                 
     @cd_lancamento_padrao,
     @cd_conta_debito,
     @cd_conta_credito,
     @cd_historico_contabil,
     @nm_historico_ativo,
     @vl_ativo_contabilizacao,
     @nm_complemento_ativo,
     @cd_usuario      

   delete from #Grupo_Contabilizacao_Baixa where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end


--deleta tabela temporária

drop table #bem
drop table #calculo_bem

end

