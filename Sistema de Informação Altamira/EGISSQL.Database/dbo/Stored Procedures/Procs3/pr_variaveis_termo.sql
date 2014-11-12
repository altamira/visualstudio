CREATE PROCEDURE pr_variaveis_termo
@ic_parametro int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Lista Empresa
-------------------------------------------------------------------------------
  begin
   
    select
      e.nm_empresa,
      e.nm_endereco_empresa,
      e.cd_cgc_empresa,
      e.cd_iest_empresa,
      est.nm_estado,
      cid.nm_cidade,
      e.cd_cep_empresa,
      e.nm_bairro_empresa

    from
      egisadmin.dbo.empresa e    

    left outer join
      Estado est
    on
      e.cd_estado = est.cd_estado

    left outer join
      Cidade cid
    on
      e.cd_cidade = cid.cd_cidade

  end -- If @ic_parametro = 1

else  
  return
    



