

CREATE procedure pr_consulta_codigo_vendedor_duplicata

@nm_fantasia_vendedor char(15)

as

  select
     1 as id,
     isnull(cd_fornecedor,0) as cd_fornecedor,
     null as cd_empresa_diversa,
     null as cd_favorecido_empresa_div
  into #TmpFornecedor
  from fornecedor
  where Upper(nm_fantasia_fornecedor) = Upper(@nm_fantasia_vendedor)

  select Top 1
         1 as id,
         null as cd_fornecedor, 
         a.cd_empresa_diversa,
         b.cd_favorecido_empresa_div
  into #TmpEmpresaDiversa
  from empresa_diversa a,
       favorecido_empresa b
  where Upper(sg_empresa_diversa) = Upper(Substring(@nm_fantasia_vendedor,1,10)) and
        a.cd_empresa_diversa = b.cd_empresa_diversa

  select * 
  into #TmpFinal
  from #TmpEmpresaDiversa
  UNION
  select * from #TmpFornecedor

  select 
         id,
         max(cd_fornecedor)             as cd_fornecedor,
         max(cd_empresa_diversa)        as cd_empresa_diversa, 
         max(cd_favorecido_empresa_div) as cd_favorecido_empresa_div
  from #TmpFinal
  group by id


