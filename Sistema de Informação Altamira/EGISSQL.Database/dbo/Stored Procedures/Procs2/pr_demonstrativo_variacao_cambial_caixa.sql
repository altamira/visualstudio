
--sp_helptext pr_demonstrativo_variacao_cambial_caixa
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EGISSQL
--Objetivo         : Consulta do Demonstrativo da Variação Cambial
--                   Módulo Financeiro / Viagem
--Data             : 24/09/2004
--Atualizado       : 22.12.2005 - Acerto do Saldo Inicial - Carlos Fernandes
--                 : 02.01.2006 - Acertos Diversos        - Carlos Fernandes
--                 : 22.10.2007 - Acertos para Moeda Estrangeira - Carlos Fernandes
--                 : 12.11.2007 - Acertos no Cálculo do Saldo - Carlos Fernandes
-- 23.11.2007 - Verificação do valor da Cotação da Moeda - Carlos Fernandes
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_demonstrativo_variacao_cambial_caixa

@cd_tipo_caixa  int        = 0,
@dt_inicio      datetime,
@dt_Fim         datetime


AS

DECLARE 

@cd_lancamento_caixa INTEGER,
@vl_saldo_acumulado  FLOAT,
@dt_saldo_caixa      datetime

--select * from caixa_saldo

    --Data do Saldo do Caixa
    select top 1 @dt_saldo_caixa = max(dt_saldo_caixa)
    from 
      dbo.Caixa_Saldo
     where 
           dt_saldo_caixa     between @dt_inicio and @dt_fim and
           cd_tipo_caixa            = @cd_tipo_caixa 

--print @dt_saldo_caixa 

set @vl_saldo_acumulado = 0  

--select * from caixa_saldo

--Inserir um registro com a Data Inicial
select 
  tc.nm_tipo_caixa,
  cs.vl_saldo_final_caixa      as vl_lancamento_caixa,
  0                            as cd_lancamento_caixa,
  m.nm_moeda,
  cd_mascara_plano_financeiro  as 'Classificacao',  
  pf.nm_conta_plano_financeiro as 'conta', 
  dt_saldo_caixa               as dt_lancamento_caixa,
  'Saldo'                      as nm_historico_lancamento,
  cast(null as varchar(60))    as 'nm_complemento',
  cd_tipo_operacao_final       as cd_tipo_operacao,
  tpf.sg_tipo_operacao,
  case tpf.sg_tipo_operacao  
    when 'E' then cs.vl_saldo_final_caixa
    else 0.00
  end as 'vl_entrada',
  case tpf.sg_tipo_operacao  
    when 'S' then cs.vl_saldo_final_caixa
    else 0.00
  end as 'vl_saida',
  0 as cd_requisicao_viagem,
  0 as cd_solicitacao,
  0 as cd_prestacao,
  isnull(cs.vl_cotacao_moeda,0.00)        as vl_cotacao,
  isnull(cs.vl_moeda_caixa_saldo,00)      as vl_moeda,
  cast(0.00 as float)                     as vl_conversao_moeda,
  isnull(cs.cd_moeda,1)                   as cd_moeda

--select * from caixa_saldo

into #TabSaldoInicial
from 
  Caixa_Saldo cs with (nolock) 
  left outer join tipo_operacao_financeira tpf on tpf.cd_tipo_operacao      = cs.cd_tipo_operacao_final 
  left outer join plano_financeiro pf          on pf.cd_plano_financeiro    = cs.cd_plano_financeiro
  left outer join Moeda m                      on m.cd_moeda                = cs.cd_moeda
  left outer join Tipo_caixa tc                on tc.cd_tipo_caixa          = cs.cd_tipo_caixa
where
   cs.dt_saldo_caixa between @dt_inicio and @dt_fim and
   cs.cd_tipo_caixa                    = @cd_tipo_caixa  and
   isnull(cs.ic_manual_caixa_saldo,'N')='S' 
order by
  cs.dt_saldo_caixa

--select * from #TabSaldoInicial

select 
  tc.nm_tipo_caixa,
  c.vl_lancamento_caixa,
  c.cd_lancamento_caixa,
  m.nm_moeda,
  cd_mascara_plano_financeiro  as 'Classificacao',  
  pf.nm_conta_plano_financeiro as 'conta', 
  c.dt_lancamento_caixa,
  c.nm_historico_lancamento,
  cast(null as varchar(60))    as 'nm_complemento',
  c.cd_tipo_operacao,
  tpf.sg_tipo_operacao,

  case tpf.sg_tipo_operacao  
    when 'E' then c.vl_lancamento_caixa
    else 0.00
  end                             as 'vl_entrada',

  case tpf.sg_tipo_operacao  
    when 'S' then c.vl_lancamento_caixa
    else 0.00
  end                             as 'vl_saida',
  c.cd_requisicao_viagem,
  c.cd_solicitacao,
  c.cd_prestacao,
  isnull(c.vl_cotacao_moeda,0)    as vl_cotacao,
  isnull(c.vl_caixa_moeda,0)      as vl_caixa_moeda,
  cast(0.00 as float)             as vl_conversao_moeda,
  isnull(c.cd_moeda,1)            as cd_moeda

--select * from caixa_lancamento

into #TabInicial
from 
  caixa_lancamento c with (nolock)
  left outer join tipo_operacao_financeira tpf on c.cd_tipo_operacao     = tpf.cd_tipo_operacao
  left outer join plano_financeiro pf          on pf.cd_plano_financeiro = c.cd_plano_financeiro
  left outer join Moeda m                      on m.cd_moeda             = c.cd_moeda
  left outer join Tipo_caixa tc                on tc.cd_tipo_caixa       = c.cd_tipo_caixa

where 
    isnull(c.cd_tipo_caixa,0) = case when isnull(@cd_tipo_caixa ,0)= 0  
                                     then isnull(c.cd_tipo_caixa,0) 
                                     else isnull(@cd_tipo_caixa,0 ) end and 
    isnull(c.dt_lancamento_caixa, getdate()) between case when isnull(@dt_inicio, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_inicio,'') end and                                                  
																										 case when isnull(@dt_fim, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_fim, '')end

order by
  c.dt_lancamento_caixa

--select * from #TabInicial
--select * from caixa_lancamento

insert into
  #TabInicial
select * from #TabSaldoInicial


select *, (vl_entrada - vl_saida) as 'SaldoLancamento' into #Tab_Aux   from #TabInicial

select *, cast(0 as Float)        as 'SaldoAcumulado'  into #Tab_Final from #Tab_Aux

--select * from #Tab_Aux
--select * from #Tab_Final


 while exists ( select top 1 * from #Tab_Aux )  
 begin  
   set @cd_lancamento_caixa = ( select top 1 cd_lancamento_caixa   
                        from #Tab_Aux   
                       order by 
                         cd_lancamento_caixa )
                         --dt_lancamento_caixa )  
  
  set @vl_saldo_acumulado = @vl_saldo_acumulado + ( select SaldoLancamento   
                                                    from #Tab_Aux   
                                                    where cd_lancamento_caixa = @cd_lancamento_caixa )   

  
  update 
    #Tab_Final
  set 
    SaldoAcumulado     = @vl_saldo_acumulado,
    vl_conversao_moeda = isnull(case when cd_moeda=1 then @vl_saldo_acumulado 
                                                     else @vl_saldo_acumulado * isnull(vl_cotacao,0) end,0) *
                         ( case when @vl_saldo_acumulado < 0 then - 1 else 1 end )
  where 
    cd_lancamento_caixa = @cd_lancamento_caixa

  
  delete #Tab_Aux where cd_lancamento_caixa = @cd_lancamento_caixa
  
end

--Apresentação da Tabela Final para Consulta

SELECT 
  tf.*,
  f.nm_funcionario 
FROM 
  #Tab_Final tf with (nolock)
  left outer join requisicao_viagem rv        on rv.cd_requisicao_viagem  = tf.cd_requisicao_viagem
  left outer join solicitacao_adiantamento sa on sa.cd_solicitacao        = tf.cd_solicitacao
  left outer join prestacao_conta          pc on pc.cd_prestacao          = tf.cd_prestacao
  left outer join funcionario f               on f.cd_funcionario         = case when isnull(rv.cd_funcionario,0)>0 
                                                                            then rv.cd_funcionario
                                                                            else 
                                                                              case when isnull(sa.cd_funcionario,0)>0 
                                                                              then sa.cd_funcionario
                                                                              else
                                                                                case when isnull(pc.cd_funcionario,0)>0 
                                                                                then pc.cd_funcionario else 0 end
                                                                              end
                                                                            end

order by
  cd_lancamento_caixa
  --dt_lancamento_caixa

-----------------------------------------------------------------------------------------


