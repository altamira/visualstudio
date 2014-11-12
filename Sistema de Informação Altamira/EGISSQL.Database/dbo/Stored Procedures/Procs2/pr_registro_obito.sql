
CREATE PROCEDURE pr_registro_obito
@ic_parametro integer,
@dt_inicial datetime,
@dt_final datetime

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos Concessionários
-------------------------------------------------------------------------------------------
begin
  select 
    e.cd_contrato,
    e.nm_falecido_evento,
    e.dt_falecimento_evento,
    e.dt_sepultamento_evento,
    e.qt_idade_evento,
    p.nm_profissao,
    e.cd_livro_evento,
    e.cd_folha_evento,
    e.cd_numero_evento
  from Evento e left join  
       Profissao p on e.cd_profissao = p.cd_profissao 
  where
    e.dt_falecimento_evento between @dt_inicial and @dt_final
  order by
    e.dt_falecimento_evento desc
 
end 
-------------------------------------------------------------------------------------------
