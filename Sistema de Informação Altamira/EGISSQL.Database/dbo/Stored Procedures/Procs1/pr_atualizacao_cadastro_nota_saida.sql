
-------------------------------------------------------------------------------
--sp_helptext pr_atualizacao_cadastro_nota_saida
-------------------------------------------------------------------------------
--pr_atualizacao_cadastro_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 26.04.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualizacao_cadastro_nota_saida
  @dt_inicial datetime,
  @dt_final   datetime,
  @cd_nota_saida_consulta int  = 0
as

declare c_nota_saida_item cursor for
select 
  ns.cd_nota_saida
from
  nota_saida                      ns with (nolock)
  left outer join vw_destinatario vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and      
                                                      vw.cd_destinatario      = ns.cd_cliente
where 
  dt_nota_saida between @dt_inicial and @dt_final and
  cd_nota_saida = case when @cd_nota_saida_consulta = 0 then 
                    cd_nota_saida 
                  else 
                    @cd_nota_saida_consulta 
                  end and
  dt_cancel_nota_saida is null 
order by
  cd_nota_saida


declare @cd_nota_saida int
set     @cd_nota_saida = 0

select 
  0     as 'Nota Fiscal',
  'Sim' as Erro,
  'Sim' as Atualizado
into
  #selecao
  
delete from #selecao  
    
open c_nota_saida_item  

fetch next from c_nota_saida_item into @cd_nota_saida

while (@@fetch_status <> -1)
begin
  
  select 
    ns.cd_nota_saida,
    
    case when isnull(ns.cd_cnpj_nota_saida,'') <> vw.cd_cnpj then
      vw.cd_cnpj
    else
      ns.cd_cnpj_nota_saida 
    end as cd_cnpj_nota_saida,
           
    case when isnull(ns.cd_inscest_nota_saida,'') <> vw.cd_inscestadual then
      vw.cd_inscestadual
    else
      ns.cd_inscest_nota_saida
    end as cd_inscest_nota_saida,
 
    case when isnull(ns.nm_razao_social_nota,'') <> vw.nm_razao_social then
      vw.nm_razao_social
    else  
      ns.nm_razao_social_nota
    end as nm_razao_social_nota,
        
    case when isnull(ns.nm_endereco_nota_saida,'') <> vw.nm_endereco then
      vw.nm_endereco
    else  
      ns.nm_endereco_nota_saida
    end as nm_endereco_nota_saida,
      
    case when isnull(ns.nm_compl_endereco_nota,'') <> vw.nm_complemento_endereco then
      vw.nm_complemento_endereco
    else  
      ns.nm_compl_endereco_nota
    end nm_compl_endereco_nota,
     
    case when isnull(ns.cd_numero_end_nota_saida,'') <> vw.cd_numero_endereco then
      vw.cd_numero_endereco
    else  
      ns.cd_numero_end_nota_saida
    end cd_numero_end_nota_saida,
      
    case when isnull(ns.nm_bairro_nota_saida,'') <> vw.nm_bairro then
      vw.nm_bairro
    else  
      ns.nm_bairro_nota_saida
    end nm_bairro_nota_saida,    

    --select * from vw_destinatario

    vw.cd_cep,
    vw.nm_pais,
    vw.sg_estado,
    vw.nm_cidade,
    vw.cd_ddd,
    vw.cd_telefone,
    vw.cd_fax,

--    case 
      case when ns.cd_cnpj_nota_saida <> vw.cd_cnpj then
        'S'
      else
      case when ns.cd_inscest_nota_saida <> vw.cd_inscestadual then
        'S'
      else
      case when ns.nm_razao_social_nota <> vw.nm_razao_social then
        'S'
      else
      case when ns.nm_endereco_nota_saida <> vw.nm_endereco then
        'S'
      else
      case when ns.nm_compl_endereco_nota <> vw.nm_complemento_endereco then
        'S'
      else
      case when ns.cd_numero_end_nota_saida <> vw.cd_numero_endereco then
        'S'
      else
      case when ns.nm_bairro_nota_saida <> vw.nm_bairro then
        'S' 
      else
        'N'
      end

      end 
      end
      end
      end
      end
    end Atualizar

into
  #temp
from
  nota_saida                      ns with (nolock)
  left outer join vw_destinatario vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and      
	             				      vw.cd_destinatario      = ns.cd_cliente
    where
      ns.cd_nota_saida = @cd_nota_saida

update
  #Temp
set
  Atualizar = 'S'

select * from #Temp


    if (select Atualizar from #temp where cd_nota_saida = @cd_nota_saida) = 'S'
    begin   
        --select * from nota_saida        
	update 
	  Nota_Saida
	set 
	  Nota_Saida.cd_cnpj_nota_saida       = cast(t.cd_cnpj_nota_saida as varchar(20)),
	  Nota_Saida.cd_inscest_nota_saida    = cast(t.cd_inscest_nota_saida as varchar(20)),
	  Nota_Saida.nm_razao_social_nota     = cast(t.nm_razao_social_nota as varchar(50)),
	  Nota_Saida.nm_endereco_nota_saida   = cast(t.nm_endereco_nota_saida as varchar(60)),
	  Nota_Saida.nm_compl_endereco_nota   = cast(t.nm_compl_endereco_nota as varchar(10)),
	  Nota_Saida.cd_numero_end_nota_saida = cast(t.cd_numero_end_nota_saida as varchar(10)),
	  Nota_Saida.nm_bairro_nota_saida     = cast(t.nm_bairro_nota_saida as varchar(25)),
          Nota_saida.cd_cep_nota_saida        = cast(t.cd_cep as varchar(09)),
          Nota_Saida.nm_cidade_nota_saida     = cast(t.nm_cidade as varchar(50)),
          Nota_Saida.sg_estado_nota_saida     = cast(t.sg_estado as varchar(02)),
          Nota_Saida.nm_pais_nota_saida       = cast(t.nm_pais   as varchar(30)),
          Nota_Saida.cd_telefone_nota_saida   = cast(t.cd_telefone as varchar(15)),
          Nota_saida.cd_ddd_nota_saida        = cast(t.cd_ddd      as varchar(4)),
          Nota_saida.cd_fax_nota_saida        = cast(t.cd_fax      as varchar(15))
         
	from
	  #temp t
	where
	  Nota_Saida.cd_nota_saida = @cd_nota_saida
	
        insert into #selecao values (@cd_nota_saida,'Sim','Sim')
    end
    else
    begin
        insert into #selecao values (@cd_nota_saida,'Sim','Não')
    end 

    if @@ERROR <> 0
      update #selecao set Erro = 'Sim'
    else
      update #selecao set Erro = 'Não'
 	             
    drop table #temp  	
    fetch next from c_nota_saida_item into @cd_nota_saida
end 

close      c_nota_saida_item  
deallocate c_nota_saida_item  

select * from #Selecao order by Atualizado desc, [nota fiscal]
drop table #selecao

