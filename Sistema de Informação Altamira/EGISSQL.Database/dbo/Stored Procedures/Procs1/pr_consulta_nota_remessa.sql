
CREATE PROCEDURE pr_consulta_nota_remessa
@ic_tipo_data  int = 0,
@ic_parametro  int,
@cd_nota_saida int,
@dt_inicial    datetime,
@dt_final      datetime

AS


-------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta de Notas não lançadas no controle
-------------------------------------------------------------------
begin

select
  0                           as 'Sel',

  ns.cd_nota_saida, 
  ns.cd_identificacao_nota_saida,

--   case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--     ns.cd_identificacao_nota_saida
--   else
--     ns.cd_nota_saida
--   end                            as cd_nota_saida,

  ns.dt_nota_saida, 
  ns.cd_operacao_fiscal,
  ns.cd_mascara_operacao,
  ns.nm_operacao_fiscal,
  ns.nm_fantasia_nota_saida, 
  ns.dt_saida_nota_saida, 
  ns.vl_total, 
  ns.cd_status_nota, 
  sn.nm_status_nota, 
  ns.vl_icms, 
  ns.vl_ipi, 
  ns.vl_bc_icms, 
  cast(0 as float) as 'vl_bc_ipi',
  ns.vl_produto,
  (ns.dt_nota_saida + IsNull(op.qt_prazo_operacao_fiscal, 0)) as 'dt_retorno',
  IsNull(op.ic_retorno_op_fiscal, 'N')                        as 'ic_retorno_op_fiscal',
  op.qt_prazo_operacao_fiscal                                 as 'Prazo',
  ns.dt_nota_saida + isnull(op.qt_prazo_operacao_fiscal,0)    as 'Vencimento',
  case when isnull(ns.dt_saida_nota_saida,'')='' then
    0
  else
    datediff(dd, ns.dt_nota_saida, getdate()) end as 'Dias'
from
  Nota_Saida ns                      with (nolock) 
  left outer join Status_Nota sn     with (nolock) on ns.cd_status_nota     = sn.cd_status_nota 
  left outer join Operacao_Fiscal op with (nolock) on op.cd_operacao_fiscal = ns.cd_operacao_fiscal 
  left outer join Nota_Vencimento nv with (nolock) on nv.cd_nota_saida      = ns.cd_nota_saida
where      
  ((ns.cd_nota_saida = @cd_nota_saida) or
   (@cd_nota_saida = 0 and ns.dt_nota_saida between @dt_inicial and @dt_final and
   IsNull(op.ic_retorno_op_fiscal,'N') = 'S')) and 
   nv.cd_nota_fiscal is null and
   IsNull(ns.cd_status_nota,6) in (1,2,3,5) --and
--   ns.dt_cancel_nota_saida is  Null

order by
  dt_nota_saida desc

end

---------------------------------------------------------------------------
else if @ic_parametro = 2 -- Consulta de Posição de Saldos por nota.
---------------------------------------------------------------------------
begin

  declare @cd_nota_aux       int
  declare @cd_nota_fiscal    int
  declare @vl_saldo_original float
  declare @vl_saldo_retorno  float
  declare @vl_nota_entrada   float
  declare @cd_nota_entrada   int
  declare @dt_nota_entrada   datetime
  declare @nm_obs_nota_vencimento varchar(40)
  declare @cd_item_nota      int
  declare @dt_saida_nota_saida datetime
  declare @dt_nota_saida       datetime
  declare @nm_operacao_fiscal  varchar(35)
  declare @cd_mascara_operacao char(6)
  declare @cd_identificacao_nota_saida int

  set @cd_nota_fiscal = 0

  select 

     ns.cd_identificacao_nota_saida,

     ns.cd_nota_saida,
  
     nv.cd_nota_fiscal,

--      ns.cd_nota_saida as cd_nota_fiscal, 
-- 
--      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--        ns.cd_identificacao_nota_saida
--      else
--        ns.cd_nota_saida
--      end                            as cd_nota_saida,

         ns.vl_total, 
         nvb.cd_nota_entrada,
         nvb.dt_nota_entrada, 
         nv.nm_obs_nota_vencimento,
         nvb.cd_item_nota_vencimento,
         nvb.vl_nota_entrada,
         ns.dt_saida_nota_saida,
         ns.dt_nota_saida,
         op.nm_operacao_fiscal,
         op.cd_mascara_operacao

  into #Nota_Vencimento
  from Nota_Saida ns             with (nolock) inner join
       Nota_Vencimento nv        with (nolock) on ns.cd_nota_saida      = nv.cd_nota_saida inner join
       Nota_Vencimento_Baixa nvb with (nolock) on nvb.cd_nota_saida     = nv.cd_nota_saida left outer join
       Operacao_Fiscal op        with (nolock) on op.cd_operacao_fiscal = ns.cd_operacao_fiscal 
  where 
      ns.cd_nota_saida = ( case when @cd_nota_saida = 0 then  
                                IsNull(ns.cd_nota_saida,0)
                               else @cd_nota_saida end ) 

      and 
        ((case when @ic_tipo_data = 0
             then
             ns.dt_saida_nota_saida
             else
             ns.dt_nota_saida end ) between ( case when @cd_nota_saida = 0 then  
                                                        @dt_inicial else 
                                                   (case when @ic_tipo_data = 0 then
                                                       ns.dt_saida_nota_saida else
                                                       ns.dt_nota_saida end ) end )
                                            and 
                                            ( case when @cd_nota_saida = 0 then  
                                                       @dt_final else 
                                                   (case when @ic_tipo_data = 0 then
                                                       ns.dt_saida_nota_saida else
                                                       ns.dt_nota_saida end ) end ) )
       --and
       --op.ic_retorno_op_fiscal = 'S'
         
  order by
    ns.dt_saida_nota_saida,
    ns.cd_nota_saida


--    select * from #Nota_Vencimento
 
    create table #Saldo_Final ( cd_nota_saida     int null, 
                                cd_item_nota      int null,
                                vl_saldo_original float null,
                                vl_saldo_atual    float null, 
                                cd_nota_entrada   int null,
                                vl_nota_entrada   float,
                                dt_nota_entrada   datetime null, 
                                nm_obs_nota_vencimento varchar(40) null,
                                dt_saida_nota_saida datetime null,
                                dt_nota_saida datetime null,
                                nm_operacao_fiscal varchar(35),
                                cd_mascara_operacao char(6),
                                cd_identificacao_nota_saida int )

    while exists ( select top 1 * from #Nota_Vencimento)
    begin

      if @cd_nota_fiscal <> ( select top 1 cd_nota_fiscal from #Nota_Vencimento)
        set @vl_saldo_retorno = ( select top 1 vl_total from #Nota_Vencimento) - IsNull(( select top 1 vl_nota_entrada from #Nota_Vencimento),0)
      else
        set @vl_saldo_retorno = @vl_saldo_retorno - IsNull(( select top 1 vl_nota_entrada from #Nota_Vencimento),0)

        select top 1 
          @cd_nota_aux       = cd_nota_saida,
          @cd_nota_fiscal    = cd_nota_fiscal,
          @cd_item_nota      = cd_item_nota_vencimento,
          @vl_saldo_original = vl_total,
          @cd_nota_entrada   = cd_nota_entrada,
          @vl_nota_entrada   = vl_nota_entrada,
          @dt_nota_entrada   = dt_nota_entrada,
          @nm_obs_nota_vencimento = nm_obs_nota_vencimento,
          @dt_saida_nota_saida    = dt_saida_nota_saida,
          @dt_nota_saida          = dt_nota_saida,
          @nm_operacao_fiscal     = nm_operacao_fiscal,
          @cd_mascara_operacao    = cd_mascara_operacao,
          @cd_identificacao_nota_saida = cd_identificacao_nota_saida  

        from #Nota_Vencimento

      insert into #Saldo_Final ( cd_nota_saida, 
                  	  	 cd_item_nota,
                                 vl_saldo_original, 
                                 vl_saldo_atual, 
                                 cd_nota_entrada,
                                 vl_nota_entrada,
                                 dt_nota_entrada,
                                 nm_obs_nota_vencimento,
                                 dt_saida_nota_saida,
                                 dt_nota_saida,
                                 nm_operacao_fiscal,
                                 cd_mascara_operacao,
                                 cd_identificacao_nota_saida )
      values
        ( --IsNull(@cd_nota_fiscal,0),
          IsNull(@cd_nota_aux,0),
          IsNull(@cd_item_nota,0),
          IsNull(@vl_saldo_original,0),
          IsNull(@vl_saldo_retorno,0),
          IsNull(@cd_nota_entrada,0),
          IsNull(@vl_nota_entrada,0),
          @dt_nota_entrada,
          IsNull(@nm_obs_nota_vencimento,''),
          @dt_saida_nota_saida,
          @dt_nota_saida,
          @nm_operacao_fiscal,
          @cd_mascara_operacao,
          @cd_identificacao_nota_saida)

        delete from #Nota_Vencimento where IsNull(cd_nota_fiscal,0)           = IsNull(@cd_nota_fiscal,0) and 
                                           IsNull(cd_item_nota_vencimento,0)  = IsNull(@cd_item_nota,0)


    end


  select sf.* from #Saldo_Final  sf

  drop table #Saldo_FInal
  drop table #Nota_Vencimento
            

end



