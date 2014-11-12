CREATE VIEW dbo.vw_Empresa
AS
SELECT 
  nm_empresa, 
  cd_empresa, 
  cd_usuario, 
  dt_usuario, 
  ic_imprimelogotipo, 
  nm_caminho_logo_empresa, 
  ic_imprime_traco, 
  cd_cgc_empresa,
  cd_iest_empresa,
  nm_fantasia_empresa,
  cd_telefone_empresa,
  nm_banco_empresa,
  nm_dominio_internet,
  ic_ocorrencia_empresa,
  IsNull(cd_cliente_sistema,-1) as cd_cliente_sistema,
  isnull(ic_loja_empresa,'N')   as ic_loja_empresa,
  isnull(ic_ativa_empresa,'N')  as ic_ativa_empresa
FROM 
  Empresa

