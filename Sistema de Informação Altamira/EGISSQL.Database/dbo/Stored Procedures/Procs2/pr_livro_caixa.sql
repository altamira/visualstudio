
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Rodolpho Francisco dos Santos
--               : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta de Livro Caixa
--Data           : 24/09/2004
--Atualizado     : 22.12.2005 - Acerto do Saldo Inicial - Carlos Fernandes
--               : 02.01.2006 - Acertos Diversos - Carlos Fernandes
--               : 06.11.2007 - Verificação e Acertos - Carlos Fernandes
-- 29.11.2007 - Saldo Inicial - Carlos Fernandes
-- 26.03.2009 - Sigla da Moeda - Carlos Fernandes
-- 28.05.2009 - Nome do Usuário - Carlos Fernandes
-- 07.03.2010 - Ajustes Diversos - Carlos Fernandes
-- 01.05.2010 - Ajuste no Saldo Inicial - Carlos Fernandes/Márcio Martins
-- 18.09.2010 - Verificação do Saldo Inicial - Carlos Fernandes
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_livro_caixa


@cd_tipo_caixa  int      = 0,
@dt_inicio      datetime = '',
@dt_fim         datetime = '',
@ic_parametro   int      = 0

AS

if @ic_parametro is null 
   set @ic_parametro = 0

declare @dt_inicio_saldo datetime
declare @dt_final_saldo  datetime
declare @inicio          datetime

set @dt_final_saldo  = @dt_inicio - 1

set
   @inicio = cast( cast(month(@dt_final_saldo) as char(02))+'/'+'01'+'/'+cast(year(@dt_final_saldo) as char(04)) as datetime )

set
   @inicio = convert(datetime,left(convert(varchar,@inicio,121),10)+' 00:00:00',121)

--Antes

-- set @dt_inicio_saldo = @inicio
-- set @dt_final_saldo  = @dt_inicio - 1

-- set @dt_inicio_saldo = @inicio
-- set @dt_final_saldo  = @dt_inicio - 1

--18.09.2010 --> Carlos 

set @dt_inicio_saldo = @dt_inicio
set @dt_final_saldo  = @dt_fim


--select @dt_inicio_saldo,@dt_final_saldo

DECLARE 

@cd_lancamento_caixa INTEGER,
@vl_saldo_acumulado  FLOAT,
@dt_saldo_caixa      datetime

--select * from caixa_saldo

    --Data do Saldo do Caixa

    select top 1 @dt_saldo_caixa = max(dt_saldo_caixa)
    from 
      dbo.Caixa_Saldo with (nolock)
     where 
           --dt_saldo_caixa     between @dt_inicio and @dt_fim and
           dt_saldo_caixa <= @dt_inicio and
           cd_tipo_caixa   = @cd_tipo_caixa
           and dt_saldo_caixa between @dt_inicio_saldo and @dt_final_saldo

           --and isnull(ic_manual_caixa_saldo,'N') = 'S'
    group by
      cd_tipo_caixa,
      dt_saldo_caixa
    order by
      dt_saldo_caixa desc

--print @dt_saldo_caixa 

-- select @dt_saldo_caixa

-- select * from tipo_operacao_financeira

set @vl_saldo_acumulado = 0  

--select * from caixa_saldo

--Inserir um registro com a Data Inicial

select 
  top 1
  cs.vl_saldo_final_caixa      as vl_lancamento_caixa,
  0                            as cd_lancamento_caixa,
  m.sg_moeda,
  m.nm_moeda,
  case when isnull(pf.cd_mascara_plano_financeiro,'')<>''
  then
    pf.cd_mascara_plano_financeiro
  else
    cast('' as varchar(80))
  end                          as 'Classificacao',  
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
  cast(null as varchar(20))   as cd_documento_lancamento,
  cast(null as varchar(80))   as nm_obs_caixa_lancamento,
  cs.cd_usuario

into #TabSaldoInicial
from 
  Caixa_Saldo cs                               with (nolock) 
  left outer join tipo_operacao_financeira tpf with (nolock) on tpf.cd_tipo_operacao      = cs.cd_tipo_operacao_final 
  left outer join plano_financeiro pf          with (nolock) on pf.cd_plano_financeiro    = cs.cd_plano_financeiro
  left outer join Moeda m                      with (nolock) on m.cd_moeda                = cs.cd_moeda
  
where
   --cs.dt_saldo_caixa between @dt_inicio and @dt_fim and
   cs.dt_saldo_caixa <= @dt_inicio     and 
   cs.cd_tipo_caixa  = @cd_tipo_caixa  
   --and isnull(cs.ic_manual_caixa_saldo,'N')='S' 
   and cs.dt_saldo_caixa between @dt_inicio_saldo and @dt_final_saldo

order by
  cs.dt_saldo_caixa desc

--select * from #TabSaldoInicial

select 
  c.vl_lancamento_caixa,
  c.cd_lancamento_caixa,
  m.sg_moeda,
  m.nm_moeda,
  case when isnull(pf.cd_mascara_plano_financeiro,'')<>''
  then
    pf.cd_mascara_plano_financeiro
  else
    c.nm_obs_caixa_lancamento
  end                          as 'Classificacao',  


--  cd_mascara_plano_financeiro  as 'Classificacao',  
  pf.nm_conta_plano_financeiro as 'conta', 
  c.dt_lancamento_caixa,
  c.nm_historico_lancamento,
  cast(null as varchar(60))    as 'nm_complemento',
  c.cd_tipo_operacao,
  tpf.sg_tipo_operacao,
  case tpf.sg_tipo_operacao  
    when 'E' then c.vl_lancamento_caixa
    else 0.00
  end as 'vl_entrada',
  case tpf.sg_tipo_operacao  
    when 'S' then c.vl_lancamento_caixa
    else 0.00
  end as 'vl_saida',
  c.cd_documento_lancamento,
  c.nm_obs_caixa_lancamento,
  c.cd_usuario

into #TabInicial
from 
  caixa_lancamento c                           with (nolock)
  left outer join tipo_operacao_financeira tpf with (nolock) on c.cd_tipo_operacao     = tpf.cd_tipo_operacao
  left outer join plano_financeiro pf          with (nolock) on pf.cd_plano_financeiro = c.cd_plano_financeiro
  left outer join Moeda m                      with (nolock) on m.cd_moeda             = c.cd_moeda
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

insert into
  #TabInicial
select * from #TabSaldoInicial


select *, (vl_entrada - vl_saida) as 'SaldoLancamento'
into
  #Tab_Aux
from
  #TabInicial
order by 
  dt_lancamento_caixa


select *, cast(0 as Float)        as 'SaldoAcumulado' 
into 
  #Tab_Final
from
  #Tab_Aux
order by 
  dt_lancamento_caixa


 while exists ( select top 1 * from #Tab_Aux )  
 begin  
   set @cd_lancamento_caixa = 
                      ( select top 1 cd_lancamento_caixa   
                        from #Tab_Aux   
                        order by 
                          dt_lancamento_caixa,cd_lancamento_caixa )  
  
  set @vl_saldo_acumulado = @vl_saldo_acumulado + ( select SaldoLancamento   
                                                    from #Tab_Aux   
                                                    where cd_lancamento_caixa = @cd_lancamento_caixa )   

  
  update #Tab_Final
  set SaldoAcumulado        = @vl_saldo_acumulado  
  where 
    cd_lancamento_caixa = @cd_lancamento_caixa
  
  delete #Tab_Aux where cd_lancamento_caixa = @cd_lancamento_caixa
  
end

--Mostra a tabela final

if @ic_parametro = 0
begin
   SELECT 
     tf.*,
     u.nm_fantasia_usuario 
   FROM 
     #Tab_Final tf
     left outer join egisadmin.dbo.usuario u on u.cd_usuario = tf.cd_usuario
   order by 
     dt_lancamento_caixa, cd_lancamento_caixa
end

--Mostra somente o Saldo Final do Caixa

if @ic_parametro = 9
begin
   SELECT SaldoAcumulado
     FROM #Tab_Final order by dt_lancamento_caixa, cd_lancamento_caixa   
end

