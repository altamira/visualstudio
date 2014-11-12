
-------------------------------------------------------------------------------
--pr_calculo_ciap
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do CIAP do Bem conforme Parâmetro
--Data             : 18.11.2006
--Alteração        : 20.11.2006 - Novo Parâmetro - Somente a Consulta
--                   20.11.2006 - Executar todos os parametro e dar o retorno em um unico comando. Márcio Rodrigues
--                   25.11.2006 - Deleção do Cálculo para Alteração
--                   20.12.2006 - Acerto do Saldo no Cadastro do Bem - Carlos Fernandes
--                   14.02.2007 - Verificação da atualização (%) Creditamento do Bem - Carlos fernandes
--                   26.03.2007 - Acertos diversos - Carlos Fernandes
--                   29.03.2007 - Acrescentar valor do saldo do ICMS - Salvatore.
--                   17.04.2007 - Verificação do (%) de Creditamento do Bem - Carlos Fernandes/Anderson
--                   28.04.2007 - Acertos - Carlos Fernandes
--                   02.10.2007 - Saldo Fixo de Cálculo - Carlos Fernandes 
-- 14.01.2008 - Modificação de um cálculo específico para Tipo 2 = Sem Controle de Crédito ( Sulzer )
--              A soma do saldo será realizado para a quantidade de meses faltantes na tabela
--              ciap_composicao - Carlos Fernandes
-------------------------------------------------------------------------------------------------------
create procedure pr_calculo_ciap
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_bem       int      = 0,
@cd_usuario   int      = 0,
@cd_tipo_ciap int      = 0

--Parâmetros
--0 -> Montagem do Demostrativo
--1 -> Cálculo  do Saldo
--2 -> Geral
--3 ->
--4 -> Deleção

as

--delete from ciap_demonstrativo

declare @qt_mes_periodo int
declare @qt_ano_periodo int

set @qt_mes_periodo = month(@dt_final)
set @qt_ano_periodo = year (@dt_final)

--select * from ciap
--select * from ciap_demonstrativo
--select * from coeficiente_ciap

--Atualiza a Tabela de Coeficiente

update
  coeficiente_ciap
set
  pc_creditamento_ciap = case when isnull(vl_total_saida,0)>0 and isnull(vl_total_saida_tributada,0)>0 
                         then (vl_total_saida_tributada/vl_total_saida)*100
                         else
                           case when isnull(pc_creditamento_ciap,0)=0 
                             then
                               100
                             else
                               isnull(pc_creditamento_ciap,0) end
                         end
where
  isnull(vl_total_saida,0) > 0

------------------------------------------------------------------------------
--Montagem da Tabela CIAP/Demonstrativo para o Bem
------------------------------------------------------------------------------
--Pela data de Aquisição
------------------------------------------------------------------------------

if @ic_parametro = 0
begin

select
  c.cd_ciap,
  isnull(c.vl_icms_ciap,0)           as vl_icms_ciap,
  c.dt_entrada_nota_ciap,

  --Na Geração da Tabela tem que ser a Data de Aquisição da Nota Fiscal de Entrada

  month(c.dt_entrada_nota_ciap)      as qt_mes,
  year(c.dt_entrada_nota_ciap)       as qt_ano,

  isnull(c.pc_fator_bem_ciap,0)      as pc_fator_bem_ciap,
  case when isnull(cc.pc_creditamento_ciap,0)=0 then 100
                                                else cc.pc_creditamento_ciap end as pc_creditamento_ciap,
  case when isnull(cc.qt_mes_apropriacao,0)=0   then isnull(c.qt_mes_ciap,48)
                                                else cc.qt_mes_apropriacao   end as qt_mes_apropriacao,

  isnull(c.pc_creditamento_bem_ciap,100) as pc_creditamento_bem_ciap,  
  isnull(cc.ic_usa_perc_ciap_bem,'N')    as ic_usa_perc_ciap_bem

  --cc.ic_usa_perc_ciap_bem
into 
  #CalculoCiap
from
  Ciap c
  left outer join Coeficiente_Ciap cc on 
                                         cc.cd_ano         = year(c.dt_entrada_nota_ciap)  and
                                         cc.cd_mes         = month(c.dt_entrada_nota_ciap) and
                                         cc.cd_local_bem = c.cd_local_bem

where
  isnull(c.cd_bem,0)            = case when @cd_bem = 0       then isnull(c.cd_bem,0)       else @cd_bem       end and
  isnull(c.cd_tipo_ciap,0)      = case when @cd_tipo_ciap = 0 then isnull(c.cd_tipo_ciap,0) else @cd_tipo_ciap end and
  isnull(c.ic_credito_ciap,'S') = 'S' and
  c.dt_entrada_nota_ciap is not null  and
  c.dt_baixa_ciap        is null      and                                    --Item não pode estar baixado 
  c.dt_entrada_nota_ciap <=@dt_final                                         --Entradas Menor Data processamento   
  
--select * from #CalculoCiap

declare @cd_ciap              int
declare @qt_mes               int
declare @qt_ano               int
declare @qt_mes_apropriacao   int
declare @pc_creditamento_ciap float
declare @vl_icms              decimal(25,2)
declare @vl_saldo_ciap        decimal(25,2)
declare @pc_fator_bem_ciap    float

while exists ( select top 1 cd_ciap from #CalculoCiap )
begin

  --Busca o 1o. Bem

  select top 1 
    @cd_ciap              = cd_ciap,
    @qt_mes               = qt_mes,
    @qt_ano               = qt_ano,
    @qt_mes_apropriacao   = qt_mes_apropriacao,

    -----------------------------------------------------------------------------------
    --Verifica o Local da Utilização do (%) de Creditamento
    -----------------------------------------------------------------------------------
    @pc_creditamento_ciap = case when isnull(ic_usa_perc_ciap_bem,'N')='N'
                                 then 
                                   case when isnull(pc_creditamento_bem_ciap,0)>0 and 
                                             isnull(pc_creditamento_ciap,0)<>isnull(pc_creditamento_bem_ciap,0)
                                   then
                                     isnull(pc_creditamento_bem_ciap,0)
                                   else
                                     isnull(pc_creditamento_ciap,0) end
                                 else isnull(pc_creditamento_bem_ciap,0) end,
    @vl_icms              = vl_icms_ciap,
    @pc_fator_bem_ciap    = isnull(pc_fator_bem_ciap,0)

  from
    #CalculoCiap

 
  set @vl_saldo_ciap = 0.00

  --Verifica se Existe o Demostrativo

  declare @cd_ciap_composicao int
  
  select top 1 @cd_ciap_composicao = isnull(cd_ciap,0)
  from 
    ciap_demonstrativo
  where
    cd_ciap = @cd_ciap

  set @cd_ciap_composicao = isnull(@cd_ciap_composicao,0)

  --Geração da Tabela Ciap_Demonstrativo

  if @cd_ciap_composicao=0
  begin

    declare @qt_parcela int
    set @qt_parcela = 1  
 
    while @qt_parcela <= @qt_mes_apropriacao
    begin
 
      insert into
        Ciap_Demonstrativo
      select
        @cd_ciap,
        @qt_parcela,
        cast(@qt_mes as int),
        @qt_ano,
        @pc_creditamento_ciap,
        round(@vl_icms * (@pc_creditamento_ciap/100) * (1.0000/@qt_mes_apropriacao),2),        
        @cd_usuario,
        getdate(),
        cast('01/'+cast(@qt_mes as varchar)+'/'+cast(@qt_ano as varchar) as datetime)

      set @qt_mes     = @qt_mes     +1 
      set @qt_parcela = @qt_parcela +1

     --Verifica se Houve mudança do ano

      if @qt_mes > 12
      begin
        set @qt_mes = 1
        set @qt_ano = @qt_ano + 1   
      end
             
    end

  end
 
  delete from #CalculoCiap where cd_ciap = @cd_ciap

 end


end

------------------------------------------------------------------------------
--Cálculo do Saldo 
------------------------------------------------------------------------------

if @ic_parametro=1
begin

  --Cálculo de todos os Bens com Entrada no Período

  select
    c.cd_ciap,
    isnull(c.vl_icms_ciap,0)           as vl_icms_ciap,
    c.dt_entrada_nota_ciap,

    --Data do Cálculo

    month(@dt_final)                   as qt_mes,
    year(@dt_final)                    as qt_ano,

    case when isnull(cc.pc_creditamento_ciap,0)=0 then 100
                                                  else isnull(cc.pc_creditamento_ciap,0) end as pc_creditamento_ciap,
    case when isnull(cc.qt_mes_apropriacao,0)=0   then isnull(c.qt_mes_ciap,48)
                                                  else cc.qt_mes_apropriacao   end as qt_mes_apropriacao,
    isnull(c.pc_creditamento_bem_ciap,100) as pc_creditamento_bem_ciap,  
    isnull(cc.ic_usa_perc_ciap_bem,'N')    as ic_usa_perc_ciap_bem
    
   into 
     #CalculoSaldoCiap
   from
     Ciap c
     --Busca o Dados pela Data de Cálculo
     left outer join Coeficiente_Ciap cc on    cc.cd_ano       = year(@dt_final) and
                                               cc.cd_mes       = month(@dt_final)and
                                               cc.cd_local_bem = c.cd_local_bem
     --Busca Dados pela Data de Entrada do Bem
--      left outer join Coeficiente_Ciap ec on 
--                                                ec.cd_ano         = year(c.dt_entrada_nota_ciap)  and
--                                                ec.cd_mes         = month(c.dt_entrada_nota_ciap) and
--                                                ec.cd_local_bem = c.cd_local_bem


   where
     isnull(c.cd_bem,0)       = case when @cd_bem = 0       then isnull(c.cd_bem,0)       else @cd_bem       end and
     isnull(c.cd_tipo_ciap,0) = case when @cd_tipo_ciap = 0 then isnull(c.cd_tipo_ciap,0) else @cd_tipo_ciap end and
     isnull(c.ic_credito_ciap,'S') = 'S' and
     c.dt_entrada_nota_ciap is not null  and
     c.dt_baixa_ciap        is null      and                                    --Item não pode estar baixado 
     c.dt_entrada_nota_ciap <=@dt_final                                         --Entradas Menor Data processamento   


   select
     cd.cd_ciap,
     count(cd.qt_mes)                  as qt_saldo_mes_ciap,
     sum(
      case when isnull(c.vl_fixo_saldo_ciap,0)>0 and @dt_final = c.dt_base_fixo_saldo_ciap
      then 
        isnull(c.vl_fixo_saldo_ciap,0)
      else
        isnull(cd.vl_icms,0)
      end )                            as vl_saldo_ciap

   into
     #CiapSaldo
   from
     Ciap_Demonstrativo cd
     inner join #CalculoSaldoCiap cs on cs.cd_ciap = cd.cd_ciap
     inner join Ciap c               on c.cd_ciap  = cd.cd_ciap
     --left outer join Ciap_Saldo sc   on sc.cd_ciap = cd.cd_ciap
   where
     cd.dt_parcela_ciap <= @dt_final     
   group by
      cd.cd_ciap

   --Cálculo do Saldo Sem controle de Crédito

   select
     cd.cd_ciap,
     count(cd.qt_mes)                  as qt_saldo_mes_ciap,
     sum(
      case when isnull(c.vl_fixo_saldo_ciap,0)>0 and @dt_final = c.dt_base_fixo_saldo_ciap
      then 
        isnull(c.vl_fixo_saldo_ciap,0)
      else
        isnull(cd.vl_icms,0)
      end )                            as vl_saldo_ciap

   into
     #CiapSaldoSemControle
   from
     Ciap_Demonstrativo cd
     inner join #CalculoSaldoCiap cs on cs.cd_ciap      = cd.cd_ciap
     inner join Ciap c               on c.cd_ciap       = cd.cd_ciap
     inner join Tipo_Ciap tc         on tc.cd_tipo_ciap = c.cd_tipo_ciap
   where
     cd.dt_parcela_ciap > @dt_final     and
     isnull(ic_tipo_calculo_tipo_ciap,'N') = 'S'
   group by
      cd.cd_ciap


   --select * from ciap where cd_ciap = 1595
   --select * from #CiapSaldo
   --select * from ciap_demonstrativo where cd_ciap = 1595

   --select * from Ciap

   --Atualização do Saldo Padrão

   update
     Ciap 
   set
     qt_saldo_mes_ciap = cs.qt_saldo_mes_ciap,
     vl_saldo_ciap     = case when cs.qt_saldo_mes_ciap = 48 then 0
                         else
                         case when isnull(c.vl_fixo_saldo_ciap,0)>0 and @dt_final = c.dt_base_fixo_saldo_ciap
                         then isnull(c.vl_fixo_saldo_ciap,0)
                         else 
                              c.vl_icms_ciap -  cs.vl_saldo_ciap 
                         end
                         end,
     --pc_fator_bem_ciap = cc.pc_creditamento_ciap,
     pc_fator_bem_ciap = case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N'
                              then isnull(cc.pc_creditamento_ciap,0)
                              else isnull(c.pc_creditamento_bem_ciap,0) end,
     dt_saldo_ciap     = @dt_final,
     dt_calculo_ciap   = @dt_final
   from 
     Ciap c
   inner join #CiapSaldo cs        on cs.cd_ciap = c.cd_ciap
   inner join #CalculoSaldoCiap cc on cc.cd_ciap = c.cd_ciap


   --Atualização do Saldo Sem Controle de Crédito
 
   update
     Ciap 
   set
     qt_saldo_mes_ciap = cs.qt_saldo_mes_ciap,
     vl_saldo_ciap     = case when cs.qt_saldo_mes_ciap = 48 then 0
                         else
                         case when isnull(c.vl_fixo_saldo_ciap,0)>0 and @dt_final = c.dt_base_fixo_saldo_ciap
                         then isnull(c.vl_fixo_saldo_ciap,0)
                         else 
                            cs.vl_saldo_ciap 
                         end
                         end,
     --pc_fator_bem_ciap = cc.pc_creditamento_ciap,
     pc_fator_bem_ciap = case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N'
                              then isnull(cc.pc_creditamento_ciap,0)
                              else isnull(c.pc_creditamento_bem_ciap,0) end,
     dt_saldo_ciap     = @dt_final,
     dt_calculo_ciap   = @dt_final
   from 
     Ciap c
   inner join #CiapSaldoSemControle cs on cs.cd_ciap = c.cd_ciap
   inner join #CalculoSaldoCiap cc     on cc.cd_ciap = c.cd_ciap

   --select * from ciap_demonstrativo

   --Atualiza do (%) de Creditamento do período Calculado

   --select * from #CalculoSaldoCiap

   update
     Ciap_Demonstrativo 
   set
     --qt_fator = isnull(cc.pc_creditamento_ciap,0),
     qt_fator = case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N'
                                 then 
                                   case when isnull(cc.pc_creditamento_bem_ciap,0)>0 and 
                                             isnull(cc.pc_creditamento_ciap,0)<>isnull(cc.pc_creditamento_bem_ciap,0)
                                   then
                                     isnull(cc.pc_creditamento_bem_ciap,0)
                                   else
                                     isnull(cc.pc_creditamento_ciap,0) end
                                 else 
                                    isnull(cc.pc_creditamento_bem_ciap,0) 
                                 end,


     vl_icms = isnull(cc.vl_icms_ciap,0) * (1.00/isnull(qt_mes_apropriacao,0) * (qt_fator/100)) -- Linha Acrescentada pelo Salvatore na Sulzer.

   from
      Ciap_Demonstrativo cd 
      inner join #CalculoSaldoCiap cc on cc.cd_ciap = cd.cd_ciap and
                                         cc.qt_mes  = cd.qt_mes  and
                                         cc.qt_ano  = cd.qt_ano 

   --select * from ciap_demonstrativo

   --select * from #CiapSaldo 

   --Atualiza a Tabela de Calculo

--drop table ciap_calculo

   select
     (select top 1 isnull( max(cd_ciap),0) + 1 from ciap_calculo ) 
                       as cd_ciap,
     @dt_final         as dt_ciap_calculo,
     'S'               as ic_processado,
     @cd_usuario       as cd_usuario,
     getdate()         as dt_usuario
   into
     #ciap_calculo

   insert into
     ciap_calculo
   select
     *
   from
     #ciap_calculo
   where
     dt_ciap_calculo is not null and 
     dt_ciap_calculo not in ( select dt_ciap_calculo from ciap_calculo )
     


end

------------------------------------------------------------------------------
--Consulta do Cálculo do CIAP/Saldo 
------------------------------------------------------------------------------

if @ic_parametro=2
begin

  --select @cd_tipo_ciap

  --select * from ciap

  select
    c.cd_ciap,
    c.dt_ciap,
    isnull(c.vl_icms_ciap,0)           as ValorImposto,
    c.dt_entrada_nota_ciap             as DataEntrada,
    --month(c.dt_entrada_nota_ciap)      as qt_mes,
    --year(c.dt_entrada_nota_ciap)       as qt_ano,
    month(@dt_final)                   as qt_mes,
    year(@dt_final)                    as qt_ano,
    case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N' then
         case when isnull(c.pc_creditamento_bem_ciap,0)>0 and 
                     isnull(cc.pc_creditamento_ciap,0)<>isnull(c.pc_creditamento_bem_ciap,0)
           then
             c.pc_creditamento_bem_ciap
           else
           case when isnull(cc.pc_creditamento_ciap,0)=0
                then 100
                else cc.pc_creditamento_ciap end 
           end

     else
         c.pc_creditamento_bem_ciap
     end  as pc_creditamento_ciap,


    case when isnull(cc.qt_mes_apropriacao,0)=0   then isnull(c.qt_mes_ciap,48)
                                                  else cc.qt_mes_apropriacao   end as MesApropriacao,

    --Valor Crédito

    (isnull(c.vl_icms_ciap,0) * 
    case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N'
    then 
      case when isnull(c.pc_creditamento_bem_ciap,0)>0 and 
                isnull(cc.pc_creditamento_ciap,0)<>isnull(c.pc_creditamento_bem_ciap,0)
      then
        isnull(c.pc_creditamento_bem_ciap,0)/100
      else
      (case when isnull(cc.pc_creditamento_ciap,0)=0 
      then 100
      else cc.pc_creditamento_ciap end  /100 )
      end
    else 
      isnull(c.pc_creditamento_bem_ciap,0)/100 end

    /    

    (case when isnull(cc.qt_mes_apropriacao,0)=0  
          then isnull(c.qt_mes_ciap,48)
          else cc.qt_mes_apropriacao   end ))        as ValorCredito,

    c.cd_fornecedor,
    f.nm_fantasia_fornecedor      as Fornecedor,
    c.cd_operacao_fiscal,
    opf.nm_operacao_fiscal        as OperacaoFiscal,
    opf.cd_mascara_operacao       as CFOP,
    isnull(c.cd_nota_entrada,0)   as NotaEntrada,
    c.cd_serie_nota_fiscal,
    case when isnull(c.pc_creditamento_bem_ciap,0)>0
    then
      isnull(c.pc_creditamento_bem_ciap,0)
    else
      isnull(c.pc_fator_bem_ciap,0)
    end                           as Fator,
    c.nm_obs_ciap                 as Observacao,
    c.cd_bem,
    b.nm_bem                      as Bem,
    b.cd_patrimonio_bem           as Patrimonio,
    isnull(c.qt_saldo_mes_ciap,0) as Mes,

    (isnull(c.vl_icms_ciap,0)/isnull(c.qt_mes_ciap,48))-

    (isnull(c.vl_icms_ciap,0) * 
    case when isnull(cc.ic_usa_perc_ciap_bem,'N')='N'
    then 
      case when isnull(c.pc_creditamento_bem_ciap,0)>0 and 
                isnull(cc.pc_creditamento_ciap,0)<>isnull(c.pc_creditamento_bem_ciap,0)
      then
        isnull(c.pc_creditamento_bem_ciap,0)/100
      else
       (case when isnull(cc.pc_creditamento_ciap,0)=0 
       then 100
       else cc.pc_creditamento_ciap end  /100 )
      end
    else 
      isnull(c.pc_creditamento_bem_ciap,0)/100 end
    /    
    (case when isnull(cc.qt_mes_apropriacao,0)=0  
          then isnull(c.qt_mes_ciap,48)
          else cc.qt_mes_apropriacao   end ))       as ValorSaldoMes,

    isnull(c.vl_saldo_ciap,0)                       as SaldoCredito,
    c.dt_saldo_ciap                                 as DataSaldo,
    c.cd_tipo_ciap,
    c.ic_credito_ciap,
    qt_mes_final = ( select top 1 qt_mes from Ciap_Demonstrativo where cd_ciap = c.cd_ciap and c.qt_mes_ciap = cd_parcela ),
    qt_ano_final = ( select top 1 qt_ano from Ciap_Demonstrativo where cd_ciap = c.cd_ciap and c.qt_mes_ciap = cd_parcela ),
    isnull(c.vl_fixo_saldo_ciap,0) as vl_fixo_saldo_ciap
   into
     #ConsultaCIAP

   from
     Ciap c with(nolock)
     left outer join Coeficiente_Ciap cc on
--                                             cc.cd_ano              = year(c.dt_entrada_nota_ciap)  and
--                                             cc.cd_mes              = month(c.dt_entrada_nota_ciap) and
                                               cc.cd_ano       = year(@dt_final) and
                                               cc.cd_mes       = month(@dt_final)and
                                               cc.cd_local_bem = c.cd_local_bem

     left outer join bem b               on b.cd_bem               = c.cd_bem
     left outer join Fornecedor f        on f.cd_fornecedor        = c.cd_fornecedor
     left outer join Operacao_Fiscal opf on opf.cd_operacao_fiscal = c.cd_operacao_fiscal
--     left outer join Ciap_Saldo sc       on sc.cd_ciap = c.cd_ciap
     
   where
     isnull(c.cd_bem,0)       = case when @cd_bem = 0       then isnull(c.cd_bem,0)       else @cd_bem       end and
     isnull(c.cd_tipo_ciap,0) = case when @cd_tipo_ciap = 0 then isnull(c.cd_tipo_ciap,0) else @cd_tipo_ciap end and
     isnull(c.ic_credito_ciap,'S') = 'S' and
     c.dt_entrada_nota_ciap is not null  and
     c.dt_baixa_ciap        is null      and                                    --Item não pode estar baixado 
     --cast((@dt_final-c.dt_entrada_nota_ciap) as int ) <= isnull(cc.qt_mes_apropriacao,48) and --Verifica se Existe Saldo
     c.dt_entrada_nota_ciap <=@dt_final                                         --Entradas Menor Data processamento   
   order by
     c.dt_entrada_nota_ciap

   select
     *,
     cast(qt_mes_final as varchar) + '/' + cast(qt_ano_final as varchar) as Termino
   from
     #ConsultaCiap
   where
      ( qt_mes_final>=@qt_mes_periodo and qt_ano_final>=@qt_ano_periodo )
      or
      ( qt_mes_final<@qt_mes_periodo  and qt_ano_final>@qt_ano_periodo )
   order by
     Patrimonio,DataEntrada

--select * from ciap

end

/*
	Márcio Rodrigues
	Executar todos os parametro e dar o retorno em um unico comando.
*/

if @ic_parametro=3
begin
  --Print 'Aqui'
  exec dbo.pr_calculo_ciap 0, @dt_inicial, @dt_final, @cd_bem , @cd_usuario, @cd_tipo_ciap
  exec dbo.pr_calculo_ciap 1, @dt_inicial, @dt_final, @cd_bem , @cd_usuario, @cd_tipo_ciap
  exec dbo.pr_calculo_ciap 2, @dt_inicial, @dt_final, @cd_bem , @cd_usuario, @cd_tipo_ciap
end

--select * from bem

--Deleção do Demonstrativo

if @ic_parametro=4
begin

  select
    c.cd_ciap
  into 
     #DelecaoCiap
   from
     Ciap c
   where
     isnull(c.cd_bem,0) = case when @cd_bem = 0 then isnull(c.cd_bem,0) else @cd_bem end 

   delete from Ciap_Demonstrativo 
   where
     cd_ciap in ( select cd_ciap from #DelecaoCiap )


   drop table #DelecaoCiap

end

