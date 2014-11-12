

/****** Object:  Stored Procedure dbo.GeraLinha    Script Date: 13/12/2002 15:08:09 ******/
CREATE PROCEDURE GeraLinha
as
begin
  DECLARE @Codigo int
  Select @Codigo = Max(cd_linha)+1 from Linha
  while @Codigo < 300 
  begin
    Insert into Linha (CD_LINHA,
                       IC_LINHA_ATIVA,
                       NM_LINHA,
                       QT_INTERVALO_DISCAGEM,
                       IC_TIPO_LINHA,
                       NM_PREFIXO_DISCAGEM,
                       QT_TENTATIVA,
                       QT_INTERVALO_TENTATIVA,
                       IC_STATUS_LINHA,
                       QT_FAX_ENVIADOS,
                       QT_FAX_FALHA,
                       QT_REDISCAGEM,
                       CD_USUARIO)
                     values ( @Codigo,
                                   'S',
                               'Linha '+Convert(Varchar(10),@Codigo),
                                     30,
                                    'P',
                                     '0',
                                      3,
                                     30,
                                     'A',
                                      10,
                                      10,
                                      3,
                                      @CODIGO)    
    SET @CODIGO = @CODIGO + 1        
  end
  
end


