
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
--                     : 30.01.2007 - Contabilização - Carlos Fernandes
--                     : 06.02.2007 - Busca do Valor de Implantação
--                     : 26.02.2007 - Verificação da contabilização - Carlos Fernandes
--                     : 28.04.2007 - Contas Contábeis - Carlos Fernandes
--                     : 17.05.2007 - Ajuste da Conta Contábil - Carlos Fernandes
--                     : 31.08.2007 - Ajuste da Data de Aquisição - Carlos Fernandes
--                     : 22.10.2007 - Verificação do Valor Fixo de Depreciação - Carlos Fernandes
-- 19.12.2008 - Checagem do Cálculo do Ativo - Carlos Fernandes
-------------------------------------------------------------------------------------------------

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
  parametro_ativo with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--Cálculo da Depreciação

if @cd_tipo_calculo_ativo = 1 or @cd_tipo_calculo_ativo = 4

begin

  --delete o cálculo no período

  exec pr_zera_movimento_calculo_ativo 1,0,0,@dt_inicial,@dt_final

  --deleta a contabilização no período

  delete from ativo_contabilizacao where dt_ativo_contabilizacao = @dt_final


  --Atualiza o Valor do Bem com os Saldos de Fechamento

  --select * from valor_bem_fechamento  


  --Busca o último código de Cálculo

  declare @cd_calculo_bem int

  select @cd_calculo_bem = isnull(max(cd_calculo_bem),0) from Calculo_Bem

  if @cd_calculo_bem=0
  begin
     set @cd_calculo_bem = 1
  end

  --drop table calculo_bem

  --select * from tipo_calculo_ativo
  --select * from bem
  --select * from valor_bem
  --select * from calculo_bem
  --select * from indice_monetario_valor
  --select * from grupo_bem
  --select * from valor_bem_implantacao

  select
    identity(int,1,1)                         as cd_calculo_bem,
    b.cd_grupo_bem,
   gb.nm_grupo_bem,
    b.cd_bem,
    b.nm_bem,
    b.cd_patrimonio_bem,
    b.dt_aquisicao_bem,
    b.dt_baixa_bem,
    b.cd_centro_custo,
   sb.nm_status_bem,
   vb.vl_fixo_depreciacao_bem,
   vb.pc_producao_bem,
   vb.vl_original_bem,
   vb.vl_baixa_bem,
   vb.vl_residual_bem,
   vb.pc_depreciacao_bem,
   vb.pc_deprec_acelerada_bem,
   isnull(vb.cd_moeda,1)               as cd_moeda,

   --Valor do Índice de Cálculo = Último Índice Monetário

   (select top 1 isnull(vl_indice_monetario,0)
    from
      indice_monetario_valor with (nolock) 
    where
      @cd_indice_monetario = cd_indice_monetario
    order by
      dt_indice_monetario ) as qt_moeda_calculo_bem,
    
    --Cálculo do Valor da Depreciação

    vl_calculo_bem = case when b.dt_aquisicao_bem<=vi.dt_implantacao_valor_bem and isnull(vi.vl_depreciacao_bem,0)<>0
                     then vi.vl_depreciacao_bem
                     else    
                       --Valor Fixo de Depreciação 
                       case when isnull(vb.vl_fixo_depreciacao_bem,0)<>0 
                       then
                         vb.vl_fixo_depreciacao_bem
                       else
                        --Depreciação Acelerada  
                        (vb.vl_original_bem*
                        (case when isnull(vb.pc_deprec_acelerada_bem,0)>0 
                            then vb.pc_deprec_acelerada_bem 
                            else 
                            --Depreciação Normal
                                 case when isnull(vb.pc_depreciacao_bem,0)>0 
                                 then vb.pc_depreciacao_bem       --(%) Depreciação do Bem
                                 else
                                      gb.pc_depreciacao_grupo_bem --(%) Depreciação do Grupo do Bem
                                 end
                            end) /100)/12
                       end
                     end,         

    pc_calculo_bem = ( case when isnull(vb.pc_deprec_acelerada_bem,0)>0 
                            then vb.pc_deprec_acelerada_bem 
                            else case when isnull(vb.pc_depreciacao_bem,0)>0 
                                 then vb.pc_depreciacao_bem else
                                      gb.pc_depreciacao_grupo_bem end
                            end),

    vl_deprec_acumulada_bem  = 0.00,
    vl_saldo_depreciacao_bem = 0.00,
    pc_saldo_depreciacao_bem = 0.00,
    pc_depreciado_bem        = 0.00
  
  into
   #bem
  from
    bem b                                    with (nolock) 
    inner join status_bem sb                 with (nolock) on sb.cd_status_bem = b.cd_status_bem
    inner join valor_bem                  vb with (nolock) on vb.cd_bem        = b.cd_bem
    inner join grupo_bem                  gb with (nolock) on gb.cd_grupo_bem  = b.cd_grupo_bem
    left outer join valor_bem_implantacao vi with (nolock) on vi.cd_bem        = b.cd_bem
  where
    isnull(gb.ic_depreciacao_grupo_bem,'N')='S' and
    isnull(vb.vl_original_bem,0)>0              and
    isnull(sb.ic_calculo_status_bem,'N')='S'    and
    ( vb.dt_fim_depreciacao_bem is null or vb.dt_fim_depreciacao_bem>=@dt_inicial  ) and
    --vb.dt_fim_depreciacao_bem >= @dt_inicial and
    --( b.dt_baixa_bem is null or b.dt_baixa_bem between @dt_inicial and @dt_final ) -- Marcado para sulzer
    ( b.dt_baixa_bem is null or b.dt_baixa_bem > @dt_final ) and
    b.dt_aquisicao_bem <= @dt_final

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

-- select
--   *
-- from
--   #Calculo_Bem

--Atualização da Tabela Valor Bem
--select * from valor_bem

update
  valor_bem
set
  vl_dep_periodo_bem       = cb.vl_calculo_bem,
  vl_deprec_acumulada_bem  = isnull(vl_deprec_acumulada_bem,0) + cb.vl_calculo_bem,
  pc_depreciacao_bem       = cb.pc_calculo_bem
 -- pc_deprec_acelerada_bem  = cb.pc_deprec_acelerada_bem,
  
from
  Valor_Bem vb
  inner join #Calculo_Bem cb on cb.cd_bem = vb.cd_bem

--Atualização parte 2

update
  valor_bem
set

  vl_saldo_depreciacao_bem = vl_original_bem - isnull(vl_deprec_acumulada_bem,0),


  vl_residual_bem          = vl_original_bem - isnull(vl_deprec_acumulada_bem,0),

  --Valor da Baixa

  vl_baixa_bem             = case when isnull(vl_baixa_bem,0)=0 and b.dt_baixa_bem is not null then
                              vl_original_bem - isnull(vl_deprec_acumulada_bem,0)
                             else
                               vl_baixa_bem end,

  --(%) Depreciado do Bem

  pc_depreciado_bem        = case when vl_original_bem>0 then (isnull(vl_deprec_acumulada_bem,0)/vl_original_bem)*100 else 0.00 end,

  -- (%) Saldo a Depreciar do Bem

  pc_saldo_depreciacao_bem = case when vl_original_bem>0 then (isnull(vl_residual_bem,0)/vl_original_bem)*100 else 0.00 end,

  cd_usuario               = @cd_usuario,

  dt_usuario               = getdate()

from
  Valor_Bem vb
  inner join #Calculo_Bem cb on cb.cd_bem = vb.cd_bem
  inner join Bem b           on b.cd_bem  = vb.cd_bem


--Contabilização do Ativo Fixo ( Depreciação )
--select * from grupo_bem_contabilizacao

select
  identity(int,1,1)                     as cd_contabilizacao_ativo,
  b.cd_centro_custo,
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
  b.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

select
  identity(int,1,1)                     as cd_contabilizacao_ativo,
  b.cd_centro_custo,
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
  b.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

---------------------------------------------------------------------------------------
--Baixa do Ativo
---------------------------------------------------------------------------------------

--1. Gera uma tabela temporária com a baixa do Bem

  select
    b.cd_centro_custo,
    b.cd_grupo_bem,
   gb.nm_grupo_bem,
    b.cd_bem,
    b.nm_bem,
    b.cd_patrimonio_bem,
    b.dt_baixa_bem,
   vb.vl_original_bem,
   vb.vl_baixa_bem,
   vb.vl_residual_bem,
   vb.vl_deprec_acumulada_bem
  into
   #bembaixa
  from
    bem b
    inner join status_bem sb                 on sb.cd_status_bem = b.cd_status_bem
    inner join valor_bem                  vb on vb.cd_bem        = b.cd_bem
    inner join grupo_bem                  gb on gb.cd_grupo_bem  = b.cd_grupo_bem
  where
    isnull(vb.vl_original_bem,0)>0              and
    b.dt_baixa_bem between @dt_inicial and @dt_final
order by
  b.dt_baixa_bem

---------------------------------------------------------------------------------------
--Baixa da Aquisição
---------------------------------------------------------------------------------------

--Gera a Tabela de Contabilização

select
  identity(int,1,1)                      as cd_contabilizacao_ativo,
  bb.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(bb.vl_baixa_bem,0))         as ValorContabilizacao,
  sum(isnull(bb.vl_original_bem,0))      as ValorAquisicao,
  sum(isnull(bb.vl_baixa_bem,0))         as ValorBaixaBem,
  sum(isnull(bb.vl_residual_bem,0))      as ValorResidual
into
  #Grupo_Contabilizacao_Baixa_Aquisicao
from
  Grupo_Bem_Contabilizacao gc
  inner join #BemBaixa bb on bb.cd_grupo_bem = gc.cd_grupo_bem
where
   gc.cd_tipo_contabilizacao = 24 and --Baixa do Ativo
   bb.dt_baixa_bem between @dt_inicial and @dt_final    

group by 
  bb.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

---------------------------------------------------------------------------------------
--Baixa do Residual
---------------------------------------------------------------------------------------

--Gera a Tabela de Contabilização

select
  identity(int,1,1)                      as cd_contabilizacao_ativo,
  bb.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(bb.vl_baixa_bem,0))         as ValorContabilizacao,
  sum(isnull(bb.vl_original_bem,0))      as ValorAquisicao,
  sum(isnull(bb.vl_baixa_bem,0))         as ValorBaixaBem,
  sum(isnull(bb.vl_residual_bem,0))      as ValorResidual
into
  #Grupo_Contabilizacao_Baixa_Residual
from
  Grupo_Bem_Contabilizacao gc
  inner join #BemBaixa bb on bb.cd_grupo_bem = gc.cd_grupo_bem
where
   gc.cd_tipo_contabilizacao = 26 and --Baixa do Ativo
   bb.dt_baixa_bem between @dt_inicial and @dt_final    

group by 
  bb.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao

---------------------------------------------------------------------------------------
--Baixa da Depreciação Acumulada
---------------------------------------------------------------------------------------

--Gera a Tabela de Contabilização

select
  identity(int,1,1)                         as cd_contabilizacao_ativo,
  bb.cd_centro_custo,
  gc.cd_grupo_bem,
  gc.cd_lancamento_padrao,
  gc.cd_tipo_contabilizacao,
  sum(isnull(bb.vl_baixa_bem,0))            as ValorContabilizacao,
  sum(isnull(bb.vl_original_bem,0))         as ValorAquisicao,
  sum(isnull(bb.vl_baixa_bem,0))            as ValorBaixaBem,
  sum(isnull(bb.vl_residual_bem,0))         as ValorResidual,
  sum(isnull(bb.vl_deprec_acumulada_bem,0)) as ValorDepAcumulada
into
  #Grupo_Contabilizacao_Baixa_Depreciacao_Acumulada
from
  Grupo_Bem_Contabilizacao gc
  inner join #BemBaixa bb on bb.cd_grupo_bem = gc.cd_grupo_bem
where
   gc.cd_tipo_contabilizacao = 27 and --Baixa do Ativo
   bb.dt_baixa_bem between @dt_inicial and @dt_final    

group by 
  bb.cd_centro_custo,
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
declare @cd_centro_custo          int

--set @nm_complemento_ativo = 'Cálculo Dep. Ativo : ' + cast(@dt_final as varchar)
set @nm_complemento_ativo = 'Cálculo Ativo: ' + convert( varchar(10), @dt_final, 103 )

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
    @nm_historico_ativo      = '',
    @cd_centro_custo         = cd_centro_custo
  from
    #Grupo_Contabilizacao_Depreciacao
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta_debito_padrao,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta_credito_padrao,0)
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
    @cd_usuario,
    @cd_centro_custo      

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

--set @nm_complemento_ativo = 'Aquisição:'+cast(@dt_inicial as varchar)+' á '+cast(@dt_final as varchar)
set @nm_complemento_ativo = 'Aquisição : '+convert( varchar(10), @dt_inicial, 103 )+' á '+convert( varchar(10), @dt_final, 103 )

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
    @nm_historico_ativo      = '',
    @cd_centro_custo         = cd_centro_custo

  from
   #Grupo_Contabilizacao_Aquisicao
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta_debito_padrao,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta_credito_padrao,0)
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
     @cd_usuario,
     @cd_centro_custo      

   delete from #Grupo_Contabilizacao_Aquisicao where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end

--Baixa do Valor da Aquisição
--Faturamento quando o Egis está Intregado ou seja, é utilizado o módulo SFT

--set @nm_complemento_ativo = 'Baixa Aquisição:'+cast( @dt_inicial as varchar )+' á '+cast( @dt_final as varchar )
set @nm_complemento_ativo = 'Baixa Aquisição: '+convert( varchar(10), @dt_inicial, 103 )+' á '+convert( varchar(10), @dt_final, 103 )

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Baixa_Aquisicao )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
    @vl_ativo_contabilizacao = ValorAquisicao,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = '',
    @cd_centro_custo         = cd_centro_custo


  from
   #Grupo_Contabilizacao_Baixa_Aquisicao
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta_debito_padrao,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta_credito_padrao,0)
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
     @cd_usuario,
     @cd_centro_custo      

   delete from #Grupo_Contabilizacao_Baixa_Aquisicao where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end


--Baixa do Valor Residual


--set @nm_complemento_ativo = 'Baixa Residual:'+cast( @dt_inicial as varchar )+' á '+cast( @dt_final as varchar )
set @nm_complemento_ativo = 'Baixa Residual: '+convert( varchar(10), @dt_inicial, 103 )+' á '+convert( varchar(10), @dt_final, 103 )

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Baixa_Residual )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
    @vl_ativo_contabilizacao = ValorResidual,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = '',
    @cd_centro_custo         = cd_centro_custo
   

  from
   #Grupo_Contabilizacao_Baixa_Residual
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta_debito_padrao,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

  select
    @cd_conta_credito = isnull(cd_conta_credito_padrao,0)
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
     @cd_usuario,
     @cd_centro_custo      

   delete from #Grupo_Contabilizacao_Baixa_Residual where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end

--Baixa da Depreciação Acumulada

--set @nm_complemento_ativo = 'Baixa Dep.Acumulada:'+cast(@dt_inicial as varchar)+' á '+cast(@dt_final as varchar)
set @nm_complemento_ativo = 'Baixa Dep.Acum.: '+convert( varchar(10), @dt_inicial, 103 )+' á '+convert( varchar(10), @dt_final, 103 )

while exists ( select top 1 cd_contabilizacao_ativo from #Grupo_Contabilizacao_Baixa_Depreciacao_Acumulada )
begin

  select top 1
    @cd_contabilizacao_ativo = cd_contabilizacao_ativo,
    @cd_lancamento_padrao    = cd_lancamento_padrao,
    @cd_tipo_contabilizacao  = cd_tipo_contabilizacao,
--    @vl_ativo_contabilizacao = ValorDepAcumulada,
    @vl_ativo_contabilizacao = ValorAquisicao-ValorResidual,
    @cd_conta_debito         = 0,
    @cd_conta_credito        = 0,
    @cd_historico_contabil   = 0,
    @nm_historico_ativo      = '',
    @cd_centro_custo         = cd_centro_custo

  from
   #Grupo_Contabilizacao_Baixa_Depreciacao_Acumulada
  
  --select * from plano_conta
  --select * from lancamento_padrao

  --Conta Débito
  --select * from plano_conta
  --select * from lancamento_padrao

  select
    @cd_conta_debito = isnull(cd_conta_debito_padrao,0)
  from
    lancamento_padrao lp      
    inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_debito_padrao 
  where
    lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

  --Conta Crédito

--   select
--     @cd_conta_credito = isnull(cd_conta_credito_padrao,0)
--   from
--     lancamento_padrao lp      
--     inner join plano_conta pc on pc.cd_conta_reduzido    = lp.cd_conta_credito_padrao 
--   where
--     lp.cd_lancamento_padrao    = @cd_lancamento_padrao and
--     lp.cd_tipo_contabilizacao  = @cd_tipo_contabilizacao

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
     @cd_usuario,
     @cd_centro_custo      

   delete from #Grupo_Contabilizacao_Baixa_Depreciacao_Acumulada where @cd_contabilizacao_ativo = cd_contabilizacao_ativo

end

--deleta tabela temporária

drop table #bem
drop table #calculo_bem

end

