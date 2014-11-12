
CREATE PROCEDURE pr_consulta_fornecedor_certificado_iso
@ic_parametro as int

as

begin
-----------------------------  Realiza Pesquisa Ambos -----------------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
    select f.cd_fornecedor,
           f.nm_razao_social,
           f.cd_ddd,
           f.cd_telefone,
           f.dt_iso_fornecedor,
           f.dt_valid_iso_fornecedor,
           f.cd_classif_fornecedor,
           cl.sg_classif_fornecedor,
           f.dt_vcto_avaliacao_fornec,
           e.sg_estado,
           c.nm_cidade, 
           f.ic_iso_fornecedor,
           Upper(IsNull(f.ic_iso_fornecedor,'N')) as Certificado           
    from fornecedor f
         left outer join estado e on (f.cd_estado = e.cd_estado)
         left outer join cidade c on (f.cd_cidade = c.cd_cidade)
         left outer join classificacao_fornecedor cl on (f.cd_classif_fornecedor = cl.cd_classif_fornecedor)
  end

--***-

else
-------------------------  Realiza Pesquisa por Certificados ----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
    select f.cd_fornecedor,
           f.nm_razao_social,
           f.cd_ddd,
           f.cd_telefone,
           f.dt_iso_fornecedor,
           f.dt_valid_iso_fornecedor,
           f.cd_classif_fornecedor,
           cl.sg_classif_fornecedor,
           f.dt_vcto_avaliacao_fornec,
           e.sg_estado,
           c.nm_cidade, 
           f.ic_iso_fornecedor,
           Upper(IsNull(f.ic_iso_fornecedor,'N')) as Certificado           
    from fornecedor f
         left outer join estado e on (f.cd_estado = e.cd_estado)
         left outer join cidade c on (f.cd_cidade = c.cd_cidade)
         left outer join classificacao_fornecedor cl on (f.cd_classif_fornecedor = cl.cd_classif_fornecedor)
    Where Upper(f.ic_iso_fornecedor) = 'S'
  end

--***-

else
-----------------------------  Realiza Pesquisa nao Certificados ---------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
    select f.cd_fornecedor,
           f.nm_razao_social,
           f.cd_ddd,
           f.cd_telefone,
           f.dt_iso_fornecedor,
           f.dt_valid_iso_fornecedor,
           f.cd_classif_fornecedor,
           cl.sg_classif_fornecedor,
           f.dt_vcto_avaliacao_fornec,
           e.sg_estado,
           c.nm_cidade, 
           f.ic_iso_fornecedor,
           Upper(IsNull(f.ic_iso_fornecedor,'N')) as Certificado           
    from fornecedor f
         left outer join estado e on (f.cd_estado = e.cd_estado)
         left outer join cidade c on (f.cd_cidade = c.cd_cidade)
         left outer join classificacao_fornecedor cl on (f.cd_classif_fornecedor = cl.cd_classif_fornecedor)
    Where Upper(IsNull(f.ic_iso_fornecedor,'N')) = 'N'
  end
end

