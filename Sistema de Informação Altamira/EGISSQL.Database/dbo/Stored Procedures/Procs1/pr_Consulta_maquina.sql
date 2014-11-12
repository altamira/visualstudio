
CREATE PROCEDURE pr_Consulta_maquina
--pr_Consulta_maquina
---------------------------------------------------
--Polimold Industrial S/A                      2001
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s): Sandro Campos
--Banco de Dados: SapSQL
--Objetivo: Consultar Máquinas
--Data       : 13/03/2002
-- Atualizado: 13/01/2003 - Acertos Gerais - Daniel C. Neto
--           : 04/05/2004 - Inclusão de Campos - DANIEL DUELA
--             05/09/2006 - Modificado 
---------------------------------------------------
@ic_parametro integer,
@nm_maquina varchar (40),
@cd_maquina integer,
@nm_fantasia varchar(40)
as

begin 

  select 
    m.*,  
    tm.nm_tipo_maquina, 
    lm.nm_local_maquina as nm_descricao_local,
    gm.nm_grupo_maquina,
    cc.nm_centro_custo, 
    (case when isnull (m.ic_listagem_empresarial,'N') = 'N' then
      'Não'
    else 
      'Sim'
    end) as nm_listagem_empresarial,
    
    (case when isnull (m.ic_processo_fabricacao,'N') = 'N' then
      'Não'
    else
      'Sim'
    end) as nm_processo_fabricacao  
    from 
    maquina m
      left outer join 
    Maquina_Tipo tm 
      on m.cd_tipo_maquina = tm.cd_tipo_maquina
      left outer join 
    Local_maquina lm 
      on m.cd_local_maquina = lm.cd_local_maquina
      left outer join 
    Grupo_Maquina gm 
      on m.cd_grupo_maquina = gm.cd_grupo_maquina
      left outer join  
    Centro_Custo cc 
      on cc.cd_centro_custo = m.cd_centro_custo  
  where 
    (case when @ic_parametro = 1 then m.nm_maquina 
          when @ic_parametro = 2 then cast(m.cd_maquina as varchar)
          when @ic_parametro = 3 then m.nm_fantasia_maquina
          else cast(m.cd_maquina as varchar)end ) like   

    (case when @ic_parametro = 1 then @nm_maquina+'%'
          when @ic_parametro = 2 then cast(@cd_maquina as varchar)
          when @ic_parametro = 3 then @nm_fantasia + '%'
          else cast(m.cd_maquina as varchar) end )

  order by m.cd_maquina

end
