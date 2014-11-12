

CREATE  PROCEDURE pr_nota_saida_layout
@cd_empresa int
as

if isnull((select cd_serie_notsaida_empresa from EgisAdmin.dbo.Empresa where cd_empresa = @cd_empresa),'')=''
  raiserror('Não existe uma série de nota fiscal configurada para esta empresa! Verifique no cadastro da Empresa.', 16, 1)

select n.*
from
  nota_saida_layout n
where
  n.cd_empresa = @cd_empresa and 
  n.cd_serie_nota_fiscal = (select 
                              cd_serie_notsaida_empresa 
                            from 
                              EgisAdmin.dbo.Empresa 
                            where 
                              cd_empresa = @cd_empresa )
order by
  n.qt_linha_nota_fiscal,
  n.qt_coluna_nota_fiscal   


