
CREATE PROCEDURE pr_controle_nao_conformidade
@ic_parametro as int,
@cd_divergencia as int



as
begin

  select
    dr.*,
    f.nm_fantasia_fornecedor,
    t.nm_tecnico,
    mc.nm_motivo_recebimento
    
  from 
    Divergencia_recebimento dr left outer join
    Fornecedor f on (dr.cd_fornecedor = f.cd_fornecedor)left outer join
    Tecnico t on (dr.cd_tecnico = t.cd_tecnico)left outer join
    Motivo_recebimento mc on (dr.cd_motivo_recebimento = mc.cd_motivo_recebimento)
    

end

