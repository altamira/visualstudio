

CREATE VIEW dbo.vw_EmpresaDefault  
AS  
SELECT cd_empresa  
FROM Empresa  
WHERE ic_default = 'S'
--Where
--  cd_empresa = dbo.fn_empresa_admin()


