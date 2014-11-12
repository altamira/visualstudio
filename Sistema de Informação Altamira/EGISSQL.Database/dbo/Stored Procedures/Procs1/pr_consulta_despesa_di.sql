CREATE  PROCEDURE pr_consulta_despesa_di
-------------------------------------------------------------------------------
--pr_consulta_despesa_di
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Paulo Souza
--Banco de Dados        : EgisSql
--Objetivo              : Consulta de despesas da DI
--Data                  : 14/02/2005
-------------------------------------------------------------------------------
@nm_di varchar(20) = '',
@dt_inicial datetime,
@dt_final datetime

As
begin
  Select 0 ic_selecionado, --Informa se o item da DI foi selecionado
         di.nm_di,
         dd.cd_di_despesa,
         tdc.nm_tipo_despesa_comex,
         dd.nm_di_despesa_complemento,          
         dd.vl_di_despesa,
         di.cd_di
	From di_despesa dd
       left outer join di on (di.cd_di = dd.cd_di)
       left outer join tipo_despesa_comex tdc on (tdc.cd_tipo_despesa_comex = dd.cd_tipo_despesa_comex)
	where
    di.dt_desembaraco between @dt_inicial and @dt_final and
		IsNull(di.nm_di,'') like (case 
						                    when IsNull(@nm_di,'') = ''
                                  then di.nm_di + '%'
								                else @nm_di + '%'
							                end)
	order by 
		di.cd_di, 
    dd.cd_di_despesa
End

--exec pr_consulta_despesa_di '', '11/01/2004', '02/28/2005'



