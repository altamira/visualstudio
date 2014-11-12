

/****** Object:  Stored Procedure dbo.pr_controle_rota    Script Date: 13/12/2002 15:08:25 ******/


CREATE  procedure pr_controle_rota
@dt_inicial   datetime,
@dt_final     datetime,
@cd_cliente   int

as 

  select 
    v.nm_veiculo,				  --Veiculo
    m.cd_motorista, 			  --Motorista
    c.cd_itinerario,			  --Itinerario da Tabela Itinerario_Composicao
    i.cd_itinerario,			  --Itinerario
    n.dt_saida_nota_saida,	          --Saida
    n.cd_nota_saida,                        --Nota
    n.dt_nota_saida, 	 	          --Emissao
    f.nm_fantasia_cliente,	          --Cliente
    r.nm_vendedor,		          --Vendedor
    n.vl_total, 		                  --Valor
    n.cd_transportadora, 	                  --Transportadora
    n.nm_obs_entrega_nota_saida             --Observacao
  from 
    nota_saida n
      left outer join
    itinerario i
      on i.cd_itinerario = n.cd_itinerario  
      left outer join
    itinerario_composicao c  
      on c.cd_itinerario = i.cd_itinerario  
      left outer join
    motorista m              
      on m.cd_motorista = c.cd_motorista   
      left outer join 
    veiculo v 		     
      on v.cd_veiculo = m.cd_veiculo     
      left outer join
    cliente f
      on n.cd_cliente = f.cd_cliente
      left outer join
    vendedor r
      on n.cd_vendedor = r.cd_vendedor          
   where
    n.dt_saida_nota_saida between @dt_inicial and @dt_final and
     ((f.cd_cliente=@cd_cliente) or (@cd_cliente = 0)) and 
     v.cd_veiculo is not null
  order by
    n.dt_nota_saida desc



