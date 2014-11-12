

/****** Object:  Stored Procedure dbo.pr_geo_mapa_sem_cliente1    Script Date: 13/12/2002 15:08:31 ******/

CREATE PROCEDURE pr_geo_mapa_sem_cliente1
@cd_vendedor_inicial int,
@cd_vendedor_final int

as

select distinct c.cd_vendedor,
      (select v.nm_fantasia_vendedor from Vendedor v
       where v.cd_vendedor = c.cd_vendedor) as nm_vendedor,
       c.cd_cliente,
       c.nm_fantasia_cliente,       
       c.nm_endereco_cliente+' ,'+c.cd_numero_endereco as 'nm_endereco_cliente',
       c.nm_bairro,
       c.cd_cep,
       cid.nm_cidade,
       est.sg_estado,/*
       ce.nm_endereco_cliente+' ,'+ce.cd_numero_endereco as 'nm_endereco_entrega',
       ce.nm_bairro_cliente                              as 'nm_bairro_entrega',
       ce.cd_cep_cliente                                 as 'cd_cep_entrega',
       cid1.nm_cidade                                    as 'nm_cidade_entrega',
       est1.nm_estado                                    as 'nm_estado_entrega',*/
       c.nm_divisao_area
  from Cliente c
/*  left outer join Cliente_Endereco ce
    on ce.cd_cliente=c.cd_cliente*/
  left outer join Cidade cid
    on cid.cd_cidade=c.cd_cidade
/*  left outer join Cidade cid1
    on cid1.cd_cidade=ce.cd_cidade*/
  left outer join Estado est
    on est.cd_estado=c.cd_estado
/*  left outer join Estado est1
    on est1.cd_estado=ce.cd_estado*/

where (c.cd_vendedor between @cd_vendedor_inicial and
                             @cd_vendedor_final ) and
       est.sg_estado = 'SP'   and
       c.cd_regiao>0          and
   not exists 
     ( select * from Divisao_Regiao where c.nm_divisao_area = nm_divisao_regiao)

order by c.cd_vendedor, c.nm_endereco_cliente



