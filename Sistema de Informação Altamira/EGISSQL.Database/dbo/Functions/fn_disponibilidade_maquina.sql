
CREATE FUNCTION fn_disponibilidade_maquina
(@cd_maquina       int,
 @dt_disponibilidade datetime)
RETURNS float
as 
Begin


    declare @qt_disponibilidade decimal(18,4)

    Select 
      @qt_disponibilidade = sum(IsNull(qt_hora_operacao_maquina,0)) 
    from 
      maquina_turno mt inner join 
      --Abaixo são selecionados as máquinas utilizadas conforme o dia da semana
      -----------------------------------
      (select distinct
        cd_maquina,
        cd_turno,
       1 as Dia
       from Maquina_Turno_Operacao
       --
      union all
       --
      select distinct
        cd_maquina,
        cd_turno,
        2 as Dia
      from Maquina_Turno_Operacao
      where ic_dia2_operacao_maquina = 'S'
      --
      union all
      --
     select distinct
        cd_maquina,
        cd_turno,
       3 as Dia
     from Maquina_Turno_Operacao
     where ic_dia3_operacao_maquina = 'S'
     --
     union all
     --
     select distinct
        cd_maquina,
        cd_turno,
       4 as Dia
     from Maquina_Turno_Operacao
     where ic_dia4_operacao_maquina = 'S'
     --
     union all
     --
     select distinct
        cd_maquina,
        cd_turno,
       5 as Dia
     from Maquina_Turno_Operacao
     where ic_dia5_operacao_maquina = 'S'
     --
     union all
     --
     select distinct
        cd_maquina,
        cd_turno,
       6 as Dia
     from Maquina_Turno_Operacao
     where ic_dia6_operacao_maquina = 'S'
     --
     union all
     --
     select distinct
        cd_maquina,
        cd_turno,
       7 as Dia
     from Maquina_Turno_Operacao
     where ic_dia7_operacao_maquina = 'S') mto on
  
     mt.cd_maquina = mto.cd_maquina and
     mto.dia = DATEPART(dw, @dt_disponibilidade) and
     mto.cd_turno = mt.cd_turno
   where 
      mt.cd_maquina = @cd_maquina and
      mt.ic_operacao = 'S' --  m.cd_maquina 


-- case datepart(dw,)

  return @qt_disponibilidade
end


