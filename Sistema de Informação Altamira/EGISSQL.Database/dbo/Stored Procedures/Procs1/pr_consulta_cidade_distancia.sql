
CREATE PROCEDURE pr_consulta_cidade_distancia
------------------------------------------------------------------------------ 
--GBS - Global Business Solution              2003 
------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        : Daniel C. Neto
--Banco de Dados   : EGISSQL 
--Objetivo         : Consulta a distância das cidades de origem e de destino
--Data             : 22/08/2003
--Atualizado       : 
------------------------------------------------------------------------------ 

@ic_parametro      int,
@cd_cidade_origem  int,
@cd_cidade_destino int

as
--------------------------------------------------------
if  @ic_parametro = 1 -- Consulta
--------------------------------------------------------
begin

  select
    co.nm_cidade as 'nm_cidade_origem', 
    cdest.nm_cidade as 'nm_cidade_destino',
    IsNull(sum(cd.qt_cidade_distancia),0) as 'Distancia'
  into #Temp
  from
    Cidade_Distancia cd left outer join
    Cidade co on co.cd_cidade = cd.cd_cidade_origem left outer join
    Cidade cdest on cdest.cd_cidade = cd.cd_cidade_destino
  where
    ( ( cd.cd_cidade_origem = @cd_cidade_origem ) or ( @cd_cidade_origem = 0 ) ) and
    ( ( cd.cd_cidade_destino = @cd_cidade_destino ) or ( @cd_cidade_destino = 0 ) )
  GROUP BY co.nm_cidade, cdest.nm_cidade
  order by
    co.nm_cidade     

  if ( select count(*) from #Temp ) = 1 
    begin
      declare @nm_cidade_origem  varchar(40)
      declare @nm_cidade_destino varchar(40)
      declare @qt_distancia float 

      set @nm_cidade_origem = ( select nm_cidade_origem from #Temp )
      set @nm_cidade_destino = ( select nm_cidade_destino from #Temp )
      set @qt_distancia = ( select Distancia from #Temp )

      insert into #Temp
      values
        (@nm_cidade_origem,
         @nm_cidade_destino,
         @qt_distancia )

    end

  select * from #Temp

end

