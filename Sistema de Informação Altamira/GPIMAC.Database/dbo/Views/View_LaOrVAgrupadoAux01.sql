


CREATE VIEW [dbo].[View_LaOrVAgrupadoAux01]
AS
SELECT     
	dbo.LAORV.Lo0Emp AS VwLo0Emp, 
	dbo.LAORV.Lo0PED AS VwLo0Ped, 
	CAST(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev AS char(01)) AS VwLo0Rev, 
	CAST(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcSta AS int) AS VwLo0Sit, 
	CAST('GPIMAC' AS char(20)) AS VwLo0Origem, 
	dbo.LAORV.Lo0Dat AS VwLo0Dat, 
	dbo.LAORV.Lo0DatVal AS VwLo0DatVal, 
	dbo.LAORV.Lo0Fei AS VwLo0Fei, 
	dbo.LAORV.Pc0Cod AS VwPc0Cod, 
	CAST(dbo.CAPCL.Pc0Fan AS char(100)) AS VwPc0Fan, 
	CAST(dbo.CAPCL.Pc0Nom AS char(200)) AS VwPc0Nom, 
	dbo.CAPCL.Pc0LogTipCod AS VwPc0LogTipCod, 
	CAST(dbo.CAPCL.Pc0End AS char(200)) AS VwPc0End, 
	dbo.CAPCL.Pc0EndNum AS VwPc0EndNum, 
	dbo.CAPCL.Pc0EndCpl AS VwPc0EndCpl, 
	CAST(dbo.CAPCL.Pc0Bai AS char(200)) AS VwPc0Bai, 
	dbo.CAPCL.Pc0Cep AS VwPc0Cep, 
	CAST(dbo.CAPCL.Pc0Cid AS char(200)) AS VwPc0Cid, 
	dbo.CAPCL.Pc0UfCod AS VwPc0UfCod, 
	dbo.CAPCL.Pc0TelDdd AS VwPc0TelDdd, 
	dbo.CAPCL.Pc0TelNum AS VwPc0TelNum, 
	dbo.CAPCL.Pc0TelRam AS VwPc0TelRam, 
	dbo.CAPCL.Pc0FaxDdd AS VwPc0FaxDdd, 
	dbo.CAPCL.Pc0FaxNum AS VwPc0FaxNum, 
	dbo.CAPCL.Pc0FaxRam AS VwPc0FaxRam, 
	dbo.LAORV.Pc1Cod AS VwLo0Pc1Cod, 
	CAST(dbo.CAPCL1.Pc1Nom AS char(200)) AS VwPc1Nom, 
	CAST(dbo.CAPCL1.Pc1Dep AS char(100)) AS VwPc1Dep, 
	CAST(dbo.CAPCL1.Pc1Cgo AS char(100)) 
	AS VwPc1Cgo, dbo.CAPCL1.Pc1TelDdd AS VwPc1TelDdd, 
	dbo.CAPCL1.Pc1TelNum AS VwPc1TelNum, 
	dbo.CAPCL1.Pc1TelRam AS VwPc1TelRam, 
	dbo.CAPCL1.Pc1FaxDdd AS VwPc1FaxDdd, 
	dbo.CAPCL1.Pc1FaxNum AS VwPc1FaxNum, 
	dbo.CAPCL1.Pc1FaxRam AS VwPc1FaxRam, 
	dbo.CAPCL1.Pc1CelDdd AS VwPc1CelDdd, 
	dbo.CAPCL1.Pc1CelNum AS VwPc1CelNum, 
	CAST(dbo.CAPCL1.Pc1Eml AS char(200)) AS VwPc1Eml, 
	dbo.LAORV.Lo0CvCod AS VwLo0CvCod, 
	CAST(dbo.CAREP.CVNOM AS char(200)) AS VwLo0CvNom, 
	dbo.CAREP.CVTip AS VwLo0CvTip, 
	dbo.LAORV.Lo0CpCod AS VwLo0CpCod, 
	dbo.CACPG.CPNOM AS VwLo0CpNom, 
	dbo.LAORV.Lo0Obs AS VwLo0Obs, 
	CAST(dbo.LAORV.Lo0Ref AS char(250)) AS VwLo0Ref, 
	dbo.LAORV.Lo0ImpDsc AS VwLo0ImpDsc, 
	dbo.LAORV.Lo0TipVend AS VwLo0TipVend, 
	CAST('1753-01-01' AS datetime) AS VwLo0SitDat, 
	CAST(' ' AS char(50)) AS VwLo0SitDes,
	(SELECT TOP (1) 
		LPPED
	FROM          
		dbo.LPV WITH (NOLOCK)
	WHERE      
		(dbo.LAORV.Lo0PED = LPWBCCADORCNUM)
	ORDER BY LPWBCCADORCNUM DESC) AS VwLo0LpPPed, 
	dbo.LAORV.Lo0ProbFec AS VwLo0ProbFec, 
	dbo.LAORV.Lo0DatProxCont AS VwLo0DatProxCont, 
	dbo.LAORV.Lo0TipMaterial AS VwLo0TipMaterial, 
	dbo.LAORV.Lo0NomConcorr AS VwLo0NomConcorr,
	
	ISNULL((SELECT     TOP (1) 'S' AS LAORVEMLENV_EmailEnviado
           FROM  dbo.LAORVEMLENV
           WHERE (Lo0Emp = dbo.LAORV.Lo0Emp) 
           AND   (Lo0PED = dbo.LAORV.Lo0PED) 
           AND   (Lo2EmlEnvRev = isnull(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev, '' ))
           ORDER BY Lo0Emp, Lo0PED, Lo2EmlEnvRev, Lo2EmlEnvSeq DESC), 'N') AS VwLo0RevEmlEnv, 
           
	ISNULL((SELECT     TOP (1) Lo2EmlEnvDat
           FROM  dbo.LAORVEMLENV AS LAORVEMLENV_EmailEnviadoData
           WHERE (Lo0Emp = dbo.LAORV.Lo0Emp) 
           AND   (Lo0PED = dbo.LAORV.Lo0PED) 
           AND   (Lo2EmlEnvRev = isnull(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev, '' ))
           ORDER BY Lo0Emp, Lo0PED, Lo2EmlEnvRev, Lo2EmlEnvSeq DESC), CAST('1753-01-01' AS DateTime)) AS VwLo0RevEmlEnvDat, 
           
	ISNULL((SELECT     TOP (1) Lo2EmlEnvDtH
           FROM  dbo.LAORVEMLENV AS LAORVEMLENV_EmailEnviadoDataHora
           WHERE (Lo0Emp = dbo.LAORV.Lo0Emp) 
           AND   (Lo0PED = dbo.LAORV.Lo0PED) 
           AND   (Lo2EmlEnvRev = isnull(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev, '' ))
           ORDER BY Lo0Emp, Lo0PED, Lo2EmlEnvRev, Lo2EmlEnvSeq DESC), CAST('1753-01-01' AS DateTime)) AS VwLo0RevEmlEnvDtH, 
           
	ISNULL((SELECT     TOP (1) Lo2EmlEnvUsu
           FROM  dbo.LAORVEMLENV AS LAORVEMLENV_EmailEnviadoUsuario
           WHERE (Lo0Emp = dbo.LAORV.Lo0Emp) 
           AND   (Lo0PED = dbo.LAORV.Lo0PED) 
           AND   (Lo2EmlEnvRev = isnull(dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev, '' ))
           ORDER BY Lo0Emp, Lo0PED, Lo2EmlEnvRev, Lo2EmlEnvSeq DESC), '') AS VwLo0RevEmlEnvUsu, 
           
	ISNULL((SELECT     TOP (1) Lo2EmlEnvSeq
           FROM  dbo.LAORVEMLENV AS LAORVEMLENV_1
           WHERE (Lo0Emp = dbo.LAORV.Lo0Emp) 
           AND   (Lo0PED = dbo.LAORV.Lo0PED)  
           AND   (Lo2EmlEnvRev = dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcRev)
           ORDER BY Lo0Emp, Lo0PED, Lo2EmlEnvRev, Lo2EmlEnvSeq DESC), 0) AS VwLo0RevEmlSeq
	
FROM         
	dbo.LAORV WITH (NOLOCK) LEFT OUTER JOIN
	dbo.View_INT_WBCCAD_ORCLST WITH (NOLOCK) ON dbo.LAORV.Lo0PED = dbo.View_INT_WBCCAD_ORCLST.INT_ORCLST_OrcNum LEFT OUTER JOIN
	dbo.CAREP WITH (NOLOCK) ON dbo.LAORV.Lo0CvCod = dbo.CAREP.CVCOD LEFT OUTER JOIN
	dbo.CACPG WITH (NOLOCK) ON dbo.LAORV.Lo0CpCod = dbo.CACPG.CPCOD LEFT OUTER JOIN
	dbo.CAPCL1 WITH (NOLOCK) ON dbo.LAORV.Pc0Cod = dbo.CAPCL1.Pc0Cod AND dbo.LAORV.Pc1Cod = dbo.CAPCL1.Pc1Cod LEFT OUTER JOIN
	dbo.CAPCL WITH (NOLOCK) ON dbo.LAORV.Pc0Cod = dbo.CAPCL.Pc0Cod




GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LaOrVAgrupadoAux01] TO [interclick]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_LaOrVAgrupadoAux01] TO [altanet]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[34] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "LAORV"
            Begin Extent = 
               Top = 18
               Left = 406
               Bottom = 243
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "View_INT_WBCCAD_ORCLST"
            Begin Extent = 
               Top = 54
               Left = 50
               Bottom = 303
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAREP"
            Begin Extent = 
               Top = 165
               Left = 773
               Bottom = 412
               Right = 963
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CACPG"
            Begin Extent = 
               Top = 216
               Left = 773
               Bottom = 335
               Right = 963
            End
            DisplayFlags = 344
            TopColumn = 13
         End
         Begin Table = "CAPCL1"
            Begin Extent = 
               Top = 110
               Left = 773
               Bottom = 331
               Right = 963
            End
            DisplayFlags = 344
            TopColumn = 0
         End
         Begin Table = "CAPCL"
            Begin Extent = 
               Top = 57
               Left = 774
               Bottom = 231
               Right = 964
            End
            DisplayFlags = 344
            TopColumn = 19
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 51
         Width = 284
         Width = 1500
         Width = ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupadoAux01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'1500
         Width = 1500
         Width = 2655
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6390
         Alias = 3660
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupadoAux01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_LaOrVAgrupadoAux01';

