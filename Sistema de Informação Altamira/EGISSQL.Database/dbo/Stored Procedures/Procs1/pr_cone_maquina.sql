

/****** Object:  Stored Procedure dbo.pr_cone_maquina    Script Date: 13/12/2002 15:08:15 ******/
--pr_cone_maquina
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes / Cleiton
--Quantidade de Ferramentas que estao
--Data         : 15.12.2000
--Atualizado   : 18.12.2000/Cleiton - Correçao de erros 
--               09.01.2001/Cleiton - Inserçao dos Calculos de dias de operaçao
-----------------------------------------------------------------------------------
CREATE procedure pr_cone_maquina
@CD_MAQUINA INT,
@Data DateTime
AS
select MAX(B.cd_cone)               as 'cone',
       max(b.dt_movimento_cone)     as 'data',
       MAX(B.CD_MOVIMENTO)          AS 'MOVIMENTO',
       max(D.qt_tempo_retorno_cone)   as 'QtRet', 
       retorno =
       case 
         when convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone)))) > 0 then 
                  convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone))))
         when convert(int,(max(D.qt_tempo_retorno_cone)-(@Data - max(b.dt_movimento_cone)))) <= 0 then 0
       end,
       convert(int,(@Data - max(b.dt_movimento_cone))) as 'Operacao'
INTO #TESTE1
from 
  Movimento_cone b, CONE C, ferramenta_cone d
WHERE
  B.CD_CONE = C.CD_CONE AND
  C.IC_STATUS_CONE = 1  and
  d.cd_cone=b.cd_cone
group by 
  B.CD_cone
order by
  b.cd_cone
SELECT A.*, 
       M.CD_MAQUINA,
       M.cd_usuario
  INTO #TESTE
  FROM #TESTE1 A, MOVIMENTO_CONE M
  WHERE A.MOVIMENTO = M.CD_MOVIMENTO
SELECT T.data,
       T.Cone ,
       F.nm_fantasia_ferramenta as 'fantasia_ferramenta', 
       F.nm_ferramenta          as 'ferramenta',
       FC.qt_tempo_retorno_cone as 'EstRetorno',
       T.Retorno                as 'Retorno',
       T.Operacao               as 'Operacao',
       U.cd_usuario             as 'cdusuario',
       U.nm_fantasia_usuario    as 'usuario',
       T.movimento              as 'movimento'
  FROM #TESTE T, Ferramenta_Cone FC, Ferramenta F, SapAdmin.dbo.usuario U
 WHERE T.CD_MAQUINA = @CD_MAQUINA                     AND
       FC.cd_cone = T.cone                            AND
       FC.CD_GRUPO_FERRAMENTA = F.CD_GRUPO_FERRAMENTA AND
       FC.CD_FERRAMENTA = F.CD_FERRAMENTA             and
       T.cd_usuario = U.cd_usuario
 order by T.Data desc, T.movimento desc


