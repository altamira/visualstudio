
--sp_helptext pr_ciap_modelo_c
-------------------------------------------------------------------------------
--pr_ciap_modelo_c
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Livro Ciap Modelo C
--Data             : 18.11.06
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ciap_modelo_c
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

--select * from ciap


--Dados do Bem

if @ic_parametro = 1
begin
  select
    c.cd_ciap                    as Codigo,
    c.dt_entrada_nota_ciap       as DataEntrada,
    c.cd_nota_entrada            as Nota,
    b.nm_bem                     as Bem,
    isnull(c.vl_icms_ciap,0)     as Entrada,
    isnull(c.vl_estorno_ciap,0)+
    isnull(c.vl_baixa_ciap,0)    as Saida,
    isnull(c.vl_icms_ciap,0) -
    (isnull(c.vl_estorno_ciap,0)+
    isnull(c.vl_baixa_ciap,0))   as Saldo,
    lc.qt_registro_livro_ciap
  from
    Ciap c
    left outer join Bem b on b.cd_bem = c.cd_bem
    left outer join Livro_Ciap lc on lc.cd_livro_ciap = c.cd_livro_ciap
  where
    dt_entrada_nota_ciap between @dt_inicial and @dt_final    and
    isnull(c.ic_credito_ciap,'S') = 'S' 
   

end

--Demonstrativo

if @ic_parametro = 2
begin
  --select * from coeficiente_ciap
  --select * from Mes
  --print '2'
  select
    m.nm_mes                                             as Mes,
    c.vl_total_saida_tributada                           as Tributada,
    c.vl_total_saida                                     as TotalSaida,
    case when 
         isnull(c.pc_creditamento_ciap,0)=0 
    then
        isnull(c.vl_total_saida_tributada/c.vl_total_saida,0)
    else
        isnull(c.pc_creditamento_ciap,0) end             as Coeficiente,
    
    isnull(c.vl_saldo_ciap,0)                            as Saldo,
    '1/'+cast(isnull(c.qt_mes_apropriacao,0) as varchar) as Fracao,
    case when isnull(c.vl_credito_ciap,0)=0
    then
       isnull((c.vl_total_saida_tributada/c.vl_total_saida)*c.vl_saldo_ciap*(1/c.qt_mes_apropriacao),0)
    else
       isnull(c.vl_credito_ciap,0) end                   as Credito  

  from
    Mes m
    left outer join Coeficiente_Ciap c on m.cd_mes = c.cd_mes
  where
    c.cd_ano = year(@dt_final)
  order by
    c.cd_ano,c.cd_mes
     
  
end


