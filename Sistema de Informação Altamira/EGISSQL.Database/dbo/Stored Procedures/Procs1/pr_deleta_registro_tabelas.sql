
CREATE PROCEDURE pr_deleta_registro_tabelas
As

SELECT 'ALTER TABLE ' +
       QUOTENAME( c.TABLE_NAME ) +
       ' NOCHECK CONSTRAINT ' +
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'

union all

SELECT 'ALTER TABLE ' +
       'EGISADMIN.dbo.' +Name +
       ' NOCHECK CONSTRAINT ' +
       Constraints AS ALTER_SCRIPT
FROM  EGISADMIN.dbo.vw_implantacao_admin_chaves_estrangeiras

union all

select 'Delete from '+(Case isnull(t.cd_banco_dados,0)  when 1 then 'EgisAdmin' else db_name() end)+'.dbo.' + nm_tabela
from  EGISADMIN.dbo.tabela  t
WHERE isnull(ic_implantacao_tabela,'N') = 'S' AND  
      isnull(ic_inativa_tabela, 'N') = 'N' AND  
  	   isnull(ic_sap_admin, 'N') = 'N'

union all
Select 'Go'
union all

SELECT 'ALTER TABLE ' +
       QUOTENAME( c.TABLE_NAME ) +
       ' CHECK CONSTRAINT ' +
       QUOTENAME( c.CONSTRAINT_NAME ) AS ALTER_SCRIPT
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS c
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'

union all

SELECT 'ALTER TABLE ' +
       'EGISADMIN.dbo.' +Name +
       ' CHECK CONSTRAINT ' +
       Constraints AS ALTER_SCRIPT
FROM  EGISADMIN.dbo.vw_implantacao_admin_chaves_estrangeiras

