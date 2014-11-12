

/****** Object:  Stored Procedure dbo.pr_gerencial_coleta_prd_conc_selecao    Script Date: 13/12/2002 15:08:33 ******/





CREATE      PROCEDURE pr_gerencial_coleta_prd_conc_selecao
--pr_gerencial_coleta_prd_conc_selecao
--------------------------------------------------------------------------------------
--Global Business Solution Ltda
--Stored Procedure : SQL Server Microsoft 2002  
--Carlos Cardoso Fernandes         
--Consulta Gerencial de Coleta de Merchandising
--Data          : 30.05.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
@ic_parametro Char(1),
@Rede Char(1),
@Bandeira Char(1),
@Estado Char(1),
@Regiao Char(1),
@cd_rede char(10),
@cd_bandeira char(10),
@cd_estado char(10),
@cd_regiao char(10),
@dt_inicial varchar(12),
@dt_final   varchar(12)
as
  
  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'frentesgeral')
    Drop Table FrentesGeral

  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'Contagem1')
    Drop Table Contagem1
  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'Contagem2')
    Drop Table Contagem2
  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'Resultado2')
    Drop Table Resultado2
  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'Resultado3')
    Drop Table Resultado3
  If Exists(Select name From Sysobjects
            where xtype = 'u' and
                  name = 'TotalLojas')
    Drop Table TotalLojas

  Declare @SQL as varchar(8000)

--   Declare @Rede as Char(1)
--   Declare @Bandeira as Char(1)
--   Declare @Regiao as Char(1)
--   Declare @dt_inicial as varchar(12)
--   Declare @dt_final  as varchar(12)

--   Set @Rede = 'S'
--   Set @Bandeira = 'S'
--   Set @Regiao = 'S'
--   Set @dt_inicial = '01/01/2000'
--   Set @dt_final   = '01/01/2003'

  Set @SQL ='select '

  if @Rede = 'S'
    Set @SQL = @SQL + 'red.nm_rede_loja as Rede, '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'ban.nm_bandeira_loja as Bandeira, '
  if @Estado = 'S'
    Set @SQL = @SQL + 'est.nm_estado as Estado, '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'rc.nm_regiao_coleta as Regiao , '

  Set @SQL = @SQL + 'cp.nm_categoria_produto as Categoria, '+
                    'p.nm_marca_produto as Marca,' +
                    'p.nm_Fantasia_produto Produto, '+
                    'cast(max(isnull(coi.vl_item_coleta,0))as decimal(16,2)) as PrcMax, '+
                    'cast(min(coi.vl_item_coleta)as decimal(16,2)) as PrcMin, '+
                    'cast(avg(coi.vl_item_coleta)as decimal(16,2)) as PrcMed, '+
                    'cast(max(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMax, '+
                    'cast(min(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMin, '+
                    'cast(avg(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMed, '+
                    'cast(sum(isnull(coi.qt_duzia_item_coleta,0)) as decimal(16,2)) as Duzia, '+
                    'cast(Max(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMax, '+
                    'cast(Min(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMin, '+
                    'cast(avg(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMed, '+
                    'cast(sum(isnull(coi.qt_frente_item_coleta,0)) as decimal(16,2)) as frentes '+
                  'into #frentep '+
                  'from '+
                    'produto p, '+
                    'categoria_produto cp, '+
                    'coleta co, '+
                    'coleta_item coi, '+
                    'rede_loja red, '+
                    'bandeira_loja ban, '+
                    'regiao_coleta rc, '+
                    'Estado est, '+
                    'loja_coleta loj '+
                  'where '+
                    'p.cd_agrupamento_produto = 1 and '+
                    'p.cd_categoria_produto = cp.cd_categoria_produto and '+
                    'co.dt_coleta between '+quotename(@dt_inicial,'''')+' and '+quotename(@dt_final,'''')+' and '+
                    'co.cd_loja_coleta = loj.cd_loja_coleta and '
                    if @Bandeira = 'S'
                       set @SQL = @SQL + 'Loj.cd_bandeira_loja = '+@cd_bandeira+' and '

                    set @SQL = @SQL + 'loj.cd_bandeira_loja = ban.cd_bandeira_loja and '

                    if @Rede = 'S'
                       set @SQL = @SQL + 'ban.cd_rede_loja = '+@cd_rede+' and '

                    set @SQL = @SQL + 'ban.cd_rede_loja = red.cd_rede_loja and '+
                    'co.cd_coleta = coi.cd_coleta and '+
                    'p.cd_produto = coi.cd_produto and '

                    if @Regiao = 'S'
                       set @SQL = @SQL + 'rc.cd_regiao_coleta = '+@cd_regiao+' and '

                    set @SQL = @SQL + 'rc.cd_regiao_coleta = co.cd_regiao_coleta and '

                    if @Estado = 'S'
                       set @SQL = @SQL + 'rc.cd_estado = '+@cd_Estado+' and '

                    set @SQL = @SQL + 'rc.cd_estado = est.cd_estado '+
                  'group by '
   if @Rede = 'S'
     set @SQL = @SQL + 'red.nm_rede_loja, '
   if @Bandeira = 'S'
     set @SQL = @SQL + 'ban.nm_bandeira_loja, '
   if @Estado = 'S'
     Set @SQL = @SQL + 'est.nm_estado, '
   if @Regiao = 'S'
     Set @SQL = @SQL + 'rc.nm_regiao_coleta, '
 
   Set @SQL = @SQL + 'cp.nm_categoria_produto, '+
                     'p.nm_marca_produto, '+
                     'p.nm_fantasia_produto '+

   'select '
  if @Rede = 'S'
    Set @SQL = @SQL + 'red.nm_rede_loja as Rede, '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'ban.nm_bandeira_loja as Bandeira, '
  if @Estado = 'S'
    Set @SQL = @SQL + 'est.nm_estado as Estado, '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'rc.nm_regiao_coleta as Regiao , '
   
  Set @SQL = @SQL + 'cp.nm_categoria_produto Categoria, '+
     'nc.nm_concorrente Marca, '+
     'p.nm_fantasia_col_prd_conc Produto, '+
                    'cast(max(coi.vl_item_coleta)as decimal(16,2)) as PrcMax, '+
                    'cast(min(coi.vl_item_coleta)as decimal(16,2)) as PrcMin, '+
                    'cast(avg(coi.vl_item_coleta)as decimal(16,2)) as PrcMed, '+
                    'cast(max(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMax, '+
                    'cast(min(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMin, '+
                    'cast(avg(coi.qt_duzia_item_coleta) as decimal(16,2)) as DuziaMed, '+
                    'cast(sum(isnull(coi.qt_duzia_item_coleta,0)) as decimal(16,2)) as Duzia, '+
                    'cast(Max(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMax, '+
                    'cast(Min(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMin, '+
                    'cast(avg(coi.qt_frente_item_coleta) as decimal(16,2)) as frentesMed, '+
                    'cast(sum(isnull(coi.qt_frente_item_coleta,0)) as decimal(16,2)) as frentes '+
   'into #frentec '+
   'from '+
     'Coleta_produto_concorrente p, '+
     'Concorrente nc, '+
     'categoria_produto cp, '+
     'coleta co, '+
     'coleta_item coi, '+
     'rede_loja   red, '+
     'bandeira_loja ban, '+
     'regiao_coleta rc, '+
     'Estado est, '+
     'loja_coleta   loj '+
   'where '+
     'p.cd_categoria_produto = cp.cd_categoria_produto and '+
     'co.dt_coleta between '+quotename(@dt_inicial,'''')+' and '+quotename(@dt_final,'''')+' and '+
     'co.cd_loja_coleta = loj.cd_loja_coleta and '
     if @Bandeira = 'S'
        set @SQL = @SQL + 'Loj.cd_bandeira_loja = '+@cd_bandeira+' and '
     set @SQL = @SQL + 'loj.cd_bandeira_loja = ban.cd_bandeira_loja and '
     if @Rede = 'S'
        set @SQL = @SQL + 'ban.cd_rede_loja = '+@cd_rede+' and '
     set @SQL = @SQL + 'ban.cd_rede_loja = red.cd_rede_loja and '+
                       'co.cd_coleta = coi.cd_coleta and '+
                       'p.cd_coleta_prd_concorrente = coi.cd_produto_concorrente and '+ 
                       'nc.cd_concorrente=p.cd_concorrente and ' 
     if @Regiao = 'S'
        set @SQL = @SQL + 'rc.cd_regiao_coleta = '+@cd_regiao+' and '
     set @SQL = @SQL + 'rc.cd_regiao_coleta = co.cd_regiao_coleta and '
     if @Estado = 'S'
        set @SQL = @SQL + 'rc.cd_estado = '+@cd_Estado+' and '
     set @SQL = @SQL + 'rc.cd_estado = est.cd_estado '+
   'group by '

  if @Rede = 'S'
    Set @SQL = @SQL + 'red.nm_rede_loja, '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'ban.nm_bandeira_loja, '
  if @Estado = 'S'
    Set @SQL = @SQL + 'est.nm_estado, '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'rc.nm_regiao_coleta, '
  
  Set @SQL = @SQL + 'cp.nm_categoria_produto, '+
                    'nc.nm_concorrente, '+
                    'p.nm_fantasia_col_prd_conc '+

  'select '
  if @Rede = 'S'
    Set @SQL = @SQL + 'Rede, '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'Bandeira, '
   if @Estado = 'S'
     Set @SQL = @SQL + 'Estado, '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'Regiao, '

  Set @SQL = @SQL + 'Categoria, '+
    'Marca,' + 
    'Produto, '+
    'PrcMax, '+
    'PrcMin, '+
    'PrcMed, '+
    'DuziaMax, '+
    'DuziaMin, '+
    'DuziaMed, '+
    'Duzia, '+
    'frentesMax, '+
    'frentesMin, '+
    'frentesMed, '+
    'frentes '+
  'into '+
    'frentesgeral '+
  'from ( '+
        'Select * from #frentep '+
        'Union '+
        'Select * from #frentec) as teste '

Exec(@SQL)
-- Total de Lojas da Seleção  ------------------------------------------------------

  set @SQL='SELECT DISTINCT '

  if @Rede = 'S'
    Set @SQL = @SQL + 'RL.nm_rede_loja, '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'BL.nm_bandeira_loja, '
  if @Estado = 'S'
    Set @SQL = @SQL + 'ES.nm_estado, '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'rc.nm_regiao_coleta, ' 

    
  Set @SQL = @SQL + 'COUNT(1) AS NUMEROTOTAL '+
                    'INTO TOTALLOJAS '+
                    'FROM LOJA_REGIAO_COLETA LRC, '+
                    'LOJA_COLETA LC, '+
                    'BANDEIRA_LOJA BL, '+
                    'REDE_LOJA RL, '+
                    'REGIAO_COLETA RC, '+
                    'ESTADO ES '+
                    'WHERE (LC.CD_LOJA_COLETA=LRC.CD_LOJA_COLETA) AND '+
                    '(LRC.CD_REGIAO_COLETA=RC.CD_REGIAO_COLETA) AND '+
                    '(RC.CD_ESTADO=ES.CD_ESTADO) AND '+
                    '(LC.CD_BANDEIRA_LOJA=BL.CD_BANDEIRA_LOJA) AND '+
                    '(BL.CD_REDE_LOJA=RL.CD_REDE_LOJA) AND '

  if @Rede = 'S'
    Set @SQL = @SQL + '(RL.CD_REDE_LOJA='+@CD_REDE+') AND '
  if @Bandeira = 'S'
    Set @SQL = @SQL + '(BL.CD_BANDEIRA_LOJA='+@CD_BANDEIRA+') AND '
  if @Estado = 'S'
    Set @SQL = @SQL + '(ES.CD_ESTADO='+@CD_ESTADO+') AND '
  if @Regiao = 'S'
    Set @SQL = @SQL + '(RC.CD_REGIAO_COLETA='+@CD_REGIAO+') AND '

  Set @SQL = @SQL + '(RL.CD_REDE_LOJA <> 0) '+  
                    'GROUP BY '
  if @Rede = 'S'
    Set @SQL = @SQL + 'RL.nm_rede_loja '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ', BL.nm_bandeira_loja '
  if @Estado = 'S'
    Set @SQL = @SQL + ', ES.nm_estado '
  if @Regiao = 'S'
    Set @SQL = @SQL + ', rc.nm_regiao_coleta '

Exec(@SQL)
------------------------------------------------------------------------------------

-- Visitas em Lojas ----------------------------------------------------------------

-- CONTAGEM1 

  Set @SQL='SELECT DISTINCT PR.NM_FANTASIA_PRODUTO AS PRODUTO '
  if @Rede = 'S'
    Set @SQL = @SQL + ', RL.nm_rede_loja '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ', BL.nm_bandeira_loja '
  if @Estado = 'S'
    Set @SQL = @SQL + ', ES.nm_estado '

  Set @SQL = @SQL + ', LC.CD_LOJA_COLETA, RC.CD_REGIAO_COLETA '

  Set @SQL = @SQL + 'INTO CONTAGEM1 '+
                    'FROM REDE_LOJA RL, '+
                    'BANDEIRA_LOJA BL, '+
                    'COLETA CL, '+
                    'COLETA_ITEM CLI, '+
                    'LOJA_REGIAO_COLETA LRC, '+
                    'LOJA_COLETA LC, '+
                    'REGIAO_COLETA RC, '+
                    'ESTADO ES, '+
                    'PRODUTO PR '+
                    'WHERE (CLI.CD_PRODUTO=PR.CD_PRODUTO) AND '+
                    '(RL.CD_REDE_LOJA=BL.CD_REDE_LOJA) AND '+
                    '(BL.CD_BANDEIRA_LOJA=LC.CD_BANDEIRA_LOJA) AND '+
                    '(LC.CD_LOJA_COLETA=CL.CD_LOJA_COLETA) AND '+ 
                    '(CL.CD_REGIAO_COLETA=RC.CD_REGIAO_COLETA) AND '+
                    '(RC.CD_ESTADO=ES.CD_ESTADO) AND '+
                    '(CL.CD_COLETA=CLI.CD_COLETA) AND '+
                    '(CL.dt_coleta between '+quotename(@dt_inicial,'''')+' and '+quotename(@dt_final,'''')+') '

  if @Rede = 'S'
    Set @SQL = @SQL + ' and (RL.CD_REDE_LOJA='+@CD_REDE+') '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ' and (BL.CD_BANDEIRA_LOJA='+@CD_BANDEIRA+') '
  if @Estado = 'S'
    Set @SQL = @SQL + ' and (ES.CD_ESTADO='+@CD_ESTADO+') '
  if @Regiao = 'S'
    Set @SQL = @SQL + ' and (RC.CD_REGIAO_COLETA='+@CD_REGIAO+') '

  Set @SQL = @SQL + ' AND (CLI.QT_FRENTE_ITEM_COLETA>0) '

  Set @SQL = @SQL + 'GROUP BY PR.NM_FANTASIA_PRODUTO '

  if @Rede = 'S'
    Set @SQL = @SQL + ', RL.nm_rede_loja '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ', BL.nm_bandeira_loja '
  if @Estado = 'S'
    Set @SQL = @SQL + ', ES.nm_estado '

  Set @SQL = @SQL + ', LC.CD_LOJA_COLETA, RC.CD_REGIAO_COLETA '

Exec(@SQL)

-- CONTAGEM2

  Set @SQL='SELECT DISTINCT PR.NM_FANTASIA_COL_PRD_CONC AS PRODUTO '
  if @Rede = 'S'
    Set @SQL = @SQL + ', RL.nm_rede_loja '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ', BL.nm_bandeira_loja '
  if @Estado = 'S'
    Set @SQL = @SQL + ', ES.nm_estado '

  Set @SQL = @SQL + ', LC.CD_LOJA_COLETA, RC.CD_REGIAO_COLETA '

  Set @SQL = @SQL + 'INTO CONTAGEM2 '+
                    'FROM REDE_LOJA RL, '+
                    'BANDEIRA_LOJA BL, '+
                    'COLETA CL, '+
                    'COLETA_ITEM CLI, '+
                    'LOJA_REGIAO_COLETA LRC, '+
                    'LOJA_COLETA LC, '+
                    'REGIAO_COLETA RC, '+
                    'ESTADO ES, '+
                    'COLETA_PRODUTO_CONCORRENTE PR '+
                    'WHERE (CLI.CD_PRODUTO_CONCORRENTE=CD_COLETA_PRD_CONCORRENTE) AND '+
                    '(RL.CD_REDE_LOJA=BL.CD_REDE_LOJA) AND '+
                    '(BL.CD_BANDEIRA_LOJA=LC.CD_BANDEIRA_LOJA) AND '+
                    '(LC.CD_LOJA_COLETA=CL.CD_LOJA_COLETA) AND '+ 
                    '(CL.CD_REGIAO_COLETA=RC.CD_REGIAO_COLETA) AND '+
                    '(RC.CD_ESTADO=ES.CD_ESTADO) AND '+
                    '(CL.CD_COLETA=CLI.CD_COLETA) AND '+
                    '(CL.dt_coleta between '+quotename(@dt_inicial,'''')+' and '+quotename(@dt_final,'''')+') '

  if @Rede = 'S'
    Set @SQL = @SQL + ' and (RL.CD_REDE_LOJA='+@CD_REDE+') '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ' and (BL.CD_BANDEIRA_LOJA='+@CD_BANDEIRA+') '
  if @Estado = 'S'
    Set @SQL = @SQL + ' and (ES.CD_ESTADO='+@CD_ESTADO+') '
  if @Regiao = 'S'
    Set @SQL = @SQL + ' and (RC.CD_REGIAO_COLETA='+@CD_REGIAO+') '

  Set @SQL = @SQL + ' AND (CLI.QT_FRENTE_ITEM_COLETA>0) '

  Set @SQL = @SQL + 'GROUP BY PR.NM_FANTASIA_COL_PRD_CONC '

  if @Rede = 'S'
    Set @SQL = @SQL + ', RL.nm_rede_loja '
  if @Bandeira = 'S'
    Set @SQL = @SQL + ', BL.nm_bandeira_loja '
  if @Estado = 'S'
    Set @SQL = @SQL + ', ES.nm_estado '

  Set @SQL = @SQL + ', LC.CD_LOJA_COLETA, RC.CD_REGIAO_COLETA '

Exec(@SQL)


SELECT * 
INTO #CONTAGEMGERAL
FROM (SELECT * FROM CONTAGEM1 UNION SELECT * FROM CONTAGEM2) AS TESTE

SELECT PRODUTO ,COUNT(1) AS TOTALVISITA 
INTO #CONTAGEMPROD
FROM #CONTAGEMGERAL
GROUP BY PRODUTO
ORDER BY PRODUTO

------------------------------------------------------------------------------------
declare @vl_total_frente float
set @vl_total_frente = 0

select @vl_total_frente =  @vl_total_frente + frentes
from frentesGeral

select nm_categoria_produto as 'Categoria', sum(vl_media_padrao) as 'VlrMedioPadrao'
into #CategoriasGeral 
from categoria_produto 
group by nm_categoria_produto

select categoria as 'Categoria', sum(frentes) as 'frentescat'
into #frentestotais
from frentesgeral 
group by categoria

select fg1.*,
       cast((isnull(fg1.frentes,0)/isnull(fg2.frentescat,0))*100 as decimal(16,2)) as 'PercFrente'
into #Resultadox
from frentesGeral fg1
left outer join #frentestotais fg2 on (fg2.categoria=fg1.categoria)

select fg1.*, cast(fg2.VlrMedioPadrao as decimal(16,2)) as 'VlrMedioPadrao'
into #Resultado1
from #Resultadox fg1
left outer join #CategoriasGeral fg2 on (fg2.categoria=fg1.categoria)

set @SQL = 'select fg1.*, fg2.numerototal as ''Lojas'' '+
           'Into Resultado2 ' +
           'from '+
           '#Resultado1 fg1, totallojas fg2 ' +
           'Where (1=1) '
  if @Rede = 'S'
    Set @SQL = @SQL + 'and (fg2.nm_rede_loja=fg1.rede) '
  if @Bandeira = 'S'
    Set @SQL = @SQL + 'and (fg2.nm_bandeira_loja=fg1.bandeira) '
  if @Estado = 'S'
    Set @SQL = @SQL + 'and (fg2.nm_estado=fg1.estado) '
  if @Regiao = 'S'
    Set @SQL = @SQL + 'and (fg2.nm_regiao_coleta=fg1.regiao) '
exec(@sql)

Set @SQL = 'select fg1.*, fg2.totalvisita as ''Visitas'' '+
           'into Resultado3 '+
           'from '+
           'Resultado2 fg1 '+
           'Left Outer Join #CONTAGEMPROD fg2 '  +
           'on (fg2.Produto=fg1.Produto)'
exec(@SQL)

select categoria,
       Marca,
       Produto,
       Cast(PrcMax as Numeric(25,2)) PrcMax,
       Cast(PrcMin as Numeric(25,2)) PrcMin,
       Cast(PrcMed as Numeric(25,2)) PrcMed,
       Cast(DuziaMax as Numeric(25,0)) DuziaMax,
       Cast(DuziaMin as Numeric(25,0)) DuziaMin,
       Cast(DuziaMed as Numeric(25,2)) DuziaMed,
       Cast(Duzia as Numeric(25,0)) Duzia,
       Cast(FrentesMax as Numeric(25,0)) FrentesMax,
       Cast(FrentesMin as Numeric(25,0)) FrentesMin,
       Cast(FrentesMed as Numeric(25,2)) FrentesMed,
       Cast(Frentes as Numeric(25,0)) Frentes,
       Cast(PercFrente as Numeric(25,0)) PercFrente,
       Visitas,
       cast(cast(visitas as decimal(16,2))/ cast(lojas as decimal(16,2)) * 100 as decimal(16,0)) as 'Penetracao',
       cast(  (cast(PrcMed as Decimal(16,2))/cast(VlrMedioPadrao as Decimal(16,2)))*100 as decimal(16,2)) as 'PosPreco',
       '' as Status
from Resultado3




