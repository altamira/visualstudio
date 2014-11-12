
CREATE  PROCEDURE pr_controle_ordem_analista  
@ic_parametro         int,   
@cd_ordem_servico     int,  
@dt_inicial           datetime,  
@dt_final             datetime  
  
AS  
-----------------------------------------------------------------------------------------------------  
--pr_controle_ordem_analista  
-----------------------------------------------------------------------------------------------------  
--GBS - Global Business Solution        2003  
-----------------------------------------------------------------------------------------------------  
--Stored Procedure: Microsoft SQL Server       2000  
--Autor(es)     : Daniel Carrasco Neto  
--Banco de Dados: EgisSQL  
--Objetivo      : Controle de Ordens de Serviço por Analista  
--            
--Data          : 14/07/2003  
--Atualizado    : 09.03.2004 - Rafael Marin Santiago - Incluido o campo departamento  
--                15.04.2004 - Rafael Marin Santiago - Acertado o campo das despesas  
--                07.12.2005 - Centro de Custo - Carlos Fernandes
--                17.12.2005 - Mostrar novo atributo para identificar se existe nota de débito gerada - Carlos/Marcos
--                30.01.2006 - Data de Vencimento para Geração de Despesa no Contas a Pagar - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------  
  
-- set @dt_inicial = convert(datetime, @dt_inicial ,101) --Define a data corretamente  
-- set @dt_final = convert(datetime, @dt_final ,101) --Define a data corretamente  
  
-------------------------------------------------------------------------------  
if @ic_parametro = 1 -- Consulta ordens de serviço no período.  
-------------------------------------------------------------------------------  
  begin  
  
    SELECT     osa.cd_ordem_servico,   
               osa.dt_ordem_servico,   
               osa.dt_lancto_ordem_servico,  
               osa.cd_cliente,   
               c.nm_fantasia_cliente,   
               a.nm_fantasia_analista,   

               --cast(osa.qt_total_normal_ordem as Datetime) as 'qt_total_normal_ordem',   
               --cast(osa.qt_total_extra_ordem as Datetime) as 'qt_total_extra_ordem',   
--               (cast(datepart(hh, cast(osa.qt_total_normal_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_normal_ordem as DATETIME)) as float) /60)) as qt_total_normal_ordem,  

               Cast(Sum(Cast(osa.qt_total_normal_ordem as Numeric(25,11))) as Numeric(25,11)) as qt_total_normal_ordem,  
               Cast(Sum(Cast(osa.qt_total_extra_ordem as Numeric(25,11))) as Numeric(25,11)) as qt_total_extra_ordem,  

--        (cast(datepart(hh, cast(osa.qt_total_extra_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_extra_ordem as DATETIME)) as float) /60)) as qt_total_extra_ordem,  
        --osa.qt_total_despesa_ordem,  
--               ISNULL(SUM(osad.vl_item_despesa_ordem),0) as qt_total_despesa_ordem,  

               Cast(0 as Float) as qt_total_despesa_ordem,  
               cast(datepart(hh, cast(osa.qt_total_desloc_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_desloc_ordem as DATETIME)) as float) /60) as qt_total_desloc_ordem,  

               --cast(( IsNull(osa.qt_total_normal_ordem,0) + IsNull(osa.qt_total_extra_ordem, 0))   
               --as Datetime) as 'Total',  
              --( IsNull(osa.qt_total_normal_ordem,0) + IsNull(osa.qt_total_extra_ordem, 0)) as 'Total',  
  
--               (cast(datepart(hh, cast(osa.qt_total_normal_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_normal_ordem as DATETIME)) as float) /60)) +    
--               (cast(datepart(hh, cast(osa.qt_total_extra_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_extra_ordem as DATETIME)) as float) /60)) as 'Total',  
  
               Cast(Sum(Cast(osa.qt_total_normal_ordem as Numeric(25,11))) as Numeric(25,11)) +  
               Cast(Sum(Cast(osa.qt_total_extra_ordem as Numeric(25,11))) as Numeric(25,11)) as 'Total',  
  
               s.nm_servico,   
               osa.nm_solicit_ordem_servico,   
               osa.cd_pedido_venda,   
               pv.dt_pedido_venda,   
               (select max(ns.cd_nota_saida) from Nota_Saida_Item pvi left outer join  
                                                  Nota_Saida ns on pvi.cd_nota_saida = ns.cd_nota_saida  
                where pvi.cd_pedido_venda = pv.cd_pedido_venda and   
                      IsNull(ns.cd_status_nota,6) in (1,2,3,5,6) ) as cd_nota_saida,  
               (select max(ns.dt_nota_saida) from Nota_Saida_Item pvi left outer join  
                                                  Nota_Saida ns on pvi.cd_nota_saida = ns.cd_nota_saida  
                where pvi.cd_pedido_venda = pv.cd_pedido_venda and   
                      IsNull(ns.cd_status_nota,6) in (1,2,3,5,6) ) as dt_nota_saida,
         osa.cd_centro_custo,
         cc.nm_centro_custo                   
         
    Into #TmpHorasAnalista  
    FROM       Ordem_Servico_Analista osa  
               Left outer join Cliente c       ON osa.cd_cliente = c.cd_cliente  
               Left outer join Analista a      ON osa.cd_analista = a.cd_analista  
               Left outer join Servico s       ON osa.cd_servico = s.cd_servico  
               Left outer join Pedido_Venda pv ON osa.cd_pedido_venda = pv.cd_pedido_venda   
               Left outer join Centro_Custo cc on osa.cd_centro_custo = cc.cd_centro_custo
--               Left outer join Ordem_Servico_Analista_Despesa osad ON osa.cd_ordem_servico = osad.cd_ordem_servico  
               
    where  
  
        IsNull(osa.cd_ordem_servico,0) =    
        ( case   
         when IsNull(@cd_ordem_servico,0) = 0 then IsNull(osa.cd_ordem_servico,0)  
         else @cd_ordem_servico  
         end  
        )  
        and  
        (  
                 ((@cd_ordem_servico = 0) and (osa.dt_ordem_servico between @dt_inicial and @dt_final))  
         or   
         (@cd_ordem_servico > 0)  
          ) 
    GROUP BY  
      osa.cd_ordem_servico,   
      osa.dt_ordem_servico,   
      osa.dt_lancto_ordem_servico,  
      osa.cd_cliente,   
      c.nm_fantasia_cliente,   
      a.nm_fantasia_analista,  
      osa.qt_total_normal_ordem,  
      osa.qt_total_extra_ordem,  
      osa.qt_total_desloc_ordem,  
      s.nm_servico,  
      osa.nm_solicit_ordem_servico,  
      osa.cd_pedido_venda,  
      pv.dt_pedido_venda,   
      pv.cd_pedido_venda,  
      osa.cd_centro_custo,
      cc.nm_centro_custo  

--select * from ordem_servico_analista_despesa

  Update #TmpHorasAnalista   
      Set qt_total_despesa_ordem = qt_total_despesa_ordem + TotDesp.TotalDespesa  
    From #TmpHorasAnalista,  
         (Select cd_ordem_servico,  
                 SUM(IsNull(qt_item_despesa_ordem * vl_item_despesa_ordem,0)) as 'TotalDespesa'  
          FROM Ordem_Servico_Analista_Despesa    
          Where vl_item_despesa_ordem <> 0  
          Group By cd_ordem_servico) as TotDesp  
    Where #TmpHorasAnalista.cd_ordem_servico = TotDesp.cd_ordem_servico  
  
    Select *  
    From #TmpHorasAnalista  
       
  end  
  
-------------------------------------------------------------------------------  
else if @ic_parametro = 2 -- Consulta ordens de serviço no período para o cadastro.  
-------------------------------------------------------------------------------  
  begin  
  
    SELECT     osa.*,  
               d.nm_departamento_cliente,  
               c.nm_fantasia_cliente,  
               a.nm_fantasia_analista,  
               ( IsNull(osa.qt_total_normal_ordem,0) + IsNull(osa.qt_total_extra_ordem, 0) +  
                 IsNull(osa.qt_total_desloc_ordem,0)) as 'Total',  
               co.nm_fantasia_contato,
               cc.nm_centro_custo  
                 
    FROM       Ordem_Servico_Analista osa Left outer join  
               Cliente c ON osa.cd_cliente = c.cd_cliente Left outer join  
               Analista a ON osa.cd_analista = a.cd_analista left outer join  
               Cliente_Contato co on co.cd_cliente = osa.cd_cliente and  
                                     co.cd_contato = osa.cd_contato       
        LEFT OUTER JOIN  
               Departamento_Cliente d  
               ON  
               osa.cd_departamento_cliente = d.cd_departamento_cliente  
        LEFT OUTER JOIN Centro_Custo cc on osa.cd_centro_custo = cc.cd_centro_custo
                           
    where  
               ((osa.cd_ordem_servico = @cd_ordem_servico) or   
                (@cd_ordem_servico = 0) and (osa.dt_ordem_servico between @dt_inicial and @dt_final))  
  
  
  end  
    
-------------------------------------------------------------------------------  
else if @ic_parametro = 3 -- Resumo de Ordens de Serviço  
-------------------------------------------------------------------------------  
  begin  
    SELECT     osa.dt_ordem_servico,  
               sum(cast(datepart(hh, cast(osa.qt_total_normal_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_normal_ordem as DATETIME)) as float) /60)) as 'Normal',  
               sum(cast(datepart(hh, cast(osa.qt_total_extra_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_extra_ordem as DATETIME)) as float) /60)) as 'Extra',  
               sum(cast(datepart(hh, cast(osa.qt_total_desloc_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_desloc_ordem as DATETIME)) as float) /60)) as 'Deslcto',  
               sum(osa.qt_total_despesa_ordem) as 'Despesa',   
               sum((cast(datepart(hh, cast(osa.qt_total_normal_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_normal_ordem as DATETIME)) as float) /60)) +    
               (cast(datepart(hh, cast(osa.qt_total_extra_ordem as DATETIME))as float)+(cast(datepart(mi, cast(osa.qt_total_extra_ordem as DATETIME)) as float) /60)))  as 'Total'  
  
    FROM       Ordem_Servico_Analista osa  
    where  
               (osa.dt_ordem_servico between @dt_inicial and @dt_final) 
    group by  
      osa.dt_ordem_servico  
end  
  

